# ruby serial communication (rs232c) for windows
# TEXCELL Ver.1.0 '05.04  Ver.2.15 '19.02
require 'fiddle/import'

module MSKernel32

   extend Fiddle::Importer
   dlload "kernel32"
   typealias("WORD", "unsigned short")
   typealias("DWORD", "unsigned int")
   typealias("BOOL", "int")
   typealias("BYTE", "char")
   COMMTIMEOUTS = struct(
      ["DWORD ReadIntervalTimeout",
       "DWORD ReadTotalTimeoutMultiplier",
       "DWORD ReadTotalTimeoutConstant",
       "DWORD WriteTotalTimeoutMultiplier",
       "DWORD WriteTotalTimeoutConstant"]
   )
   DCB = struct(
      ["DWORD DCBlength",
       "DWORD BaudRate",
       "DWORD dcbflags",
       "WORD  wReserved",
       "WORD XonLim",
       "WORD XoffLim",
       "BYTE ByteSize",
       "BYTE Parity",
       "BYTE StopBits",
       "BYTE XonChar",
       "BYTE XoffChar",
       "BYTE ErrorChar",
       "BYTE EofChar",
       "BYTE EvtChar",
       "WORD wReserved1"]
   )
   COMSTAT = struct(
      ["DWORD fflg",
       "DWORD cbInQue",
       "DWORD cbOutQue"]
   )
   extern "int CreateFileA(char*,DWORD,DWORD,void*,DWORD,DWORD,int)",:stdcall
   extern "BOOL SetupComm(int,DWORD,DWORD)",:stdcall
   extern "BOOL PurgeComm(int,DWORD)",:stdcall
   extern "BOOL SetCommTimeouts(int,void*)",:stdcall
   extern "BOOL GetCommState(int,void*)",:stdcall
   extern "BOOL SetCommState(int,void*)",:stdcall
   extern "BOOL EscapeCommFunction(int,DWORD)",:stdcall
   extern "BOOL CloseHandle(int)",:stdcall
   extern "BOOL WriteFile(int, char*,DWORD,void*,void*)",:stdcall
   extern "BOOL ClearCommError(int,void*,void*)",:stdcall
   extern "BOOL ReadFile(int,char*,DWORD,void*,void*)",:stdcall
end

class Serial

   CBR_110 = 110
   CBR_300 = 300
   CBR_600 = 600
   CBR_1200 = 1200
   CBR_2400 = 2400
   CBR_4800 = 4800
   CBR_9600 = 9600
   CBR_14400 = 14400
   CBR_19200 = 19200
   CBR_38400 = 38400
   CBR_57600 = 57600
   CBR_115200 = 115200
   CBR_128000 = 128000
   CBR_256000 = 256000
   DTR_CONTROL_DISABLE = 0x00
   DTR_CONTROL_ENABLE = 0x01
   DTR_CONTROL_HANDSHAKE = 0x02
   RTS_CONTROL_DISABLE = 0x00
   RTS_CONTROL_ENABLE = 0x01
   RTS_CONTROL_HANDSHAKE = 0x02
   RTS_CONTROL_TOGGLE = 0x03
   EVENPARITY = 2
   MARKPARITY = 3
   NOPARITY = 0
   ODDPARITY = 1
   SPACEPARITY = 4
   ONESTOPBIT = 0
   ONE5STOPBITS = 1
   TWOSTOPBITS = 2

   SETXOFF = 1
   SETXON = 2
   SETRTS = 3
   CLRRTS = 4
   SETDTR = 5
   CLRDTR = 6
   RESETDEV = 7
   SETBREAK = 8
   CLRBREAK = 9

   GENERIC_READ  = 0x80000000
   GENERIC_WRITE = 0x40000000
   OPEN_EXISTING = 3
   FILE_ATTRIBUTE_NORMAL = 0x00000080
   FILE_FLAG_OVERLAPPED  = 0x40000000
   PURGE_TXABORT = 1
   PURGE_RXABORT = 2
   PURGE_TXCLEAR = 4
   PURGE_RXCLEAR = 8

   def initialize

      @iht = -1
      @comno = 1
      @recbuf = 512; @senbuf = 512
      @bRate = CBR_9600
      @fBinary = 1
      @fParity = 1
      @fOutxCtsFlow = 1
      @fOutxDsrFlow = 1
      @fDtrControl = DTR_CONTROL_ENABLE
      @fDsrSensitivity = 1
      @fTXContinueOnXoff = 0
      @fOutX = 0
      @fInX = 0
      @fErrorChar = 0
      @fNull = 0
      @fRtsControl = RTS_CONTROL_ENABLE
      @fAbortOnError = 0
      @xonLim = 0
      @xoffLim = 0
      @byteSize = 8
      @parity = NOPARITY
      @stopbit = ONESTOPBIT
      @xonchar = 0x11
      @xoffchar = 0x13
      @errorchar = 0
      @eofchar = 0
      @evtchar = 0
      @readIntervalTimeout = 1000
      @readTotalTimeoutMultiplier = 0
      @readTotalTimeoutConstant = 0
      @writeTotalTimeoutMultiplier = 20
      @writeTotalTimeoutConstant = 1000
   end

   def send(schar)

      ilen = schar.bytesize
      wpwadd = [0].pack("I")
      bi = MSKernel32.WriteFile(@iht,schar,ilen,wpwadd,0)
      if bi != 0 then bi = nil end
      return bi
   end

   def receive

      rcvchar = nil
      dwerr = [0].pack("I")
      statcom = MSKernel32::COMSTAT.malloc
      bi = MSKernel32.ClearCommError(@iht,dwerr,statcom)
      if bi != 0
         if statcom.cbInQue > 0
            ilen = statcom.cbInQue
            dreadsize = [0].pack("I")
            MSKernel32.ReadFile(@iht,@wcrecv,ilen,dreadsize,0)
            irlen = dreadsize.unpack("I")
            rcvchar = @wcrecv.unpack("a#{irlen[0]}")[0]
         end
      end
      return rcvchar
   end

   def open

      scomno = "\\\\.\\COM#{@comno}\0"
      @iht = MSKernel32.CreateFileA(scomno,GENERIC_READ | GENERIC_WRITE,0,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0)
      ir = nil
      if @iht != -1
         ir = catch(:exit){
            @wcrecv = "\x0" * @recbuf
            bi = MSKernel32.SetupComm(@iht,@recbuf,@senbuf)
            throw :exit, -2 if bi == 0
            bi = MSKernel32.PurgeComm(@iht,PURGE_TXABORT | PURGE_RXABORT | PURGE_TXCLEAR | PURGE_RXCLEAR)
            throw :exit, -3 if bi == 0
            commtimeout = MSKernel32::COMMTIMEOUTS.malloc
            commtimeout.ReadIntervalTimeout = @readIntervalTimeout
            commtimeout.ReadTotalTimeoutMultiplier = @readTotalTimeoutMultiplier
            commtimeout.ReadTotalTimeoutConstant = @readTotalTimeoutConstant
            commtimeout.WriteTotalTimeoutMultiplier = @writeTotalTimeoutMultiplier
            commtimeout.WriteTotalTimeoutConstant = @writeTotalTimeoutConstant
            bi = MSKernel32.SetCommTimeouts(@iht,commtimeout)
            throw :exit, -4 if bi == 0
            dcb = MSKernel32::DCB.malloc
            bi = MSKernel32.GetCommState(@iht,dcb)
            throw :exit, -5 if bi == 0
            dcb.BaudRate = @bRate
            dcb.dcbflags &= ~0x0001; dcb.dcbflags |= (@fBinary & 0x1)
            dcb.dcbflags &= ~0x0002; dcb.dcbflags |= ((@fParity & 0x1) << 1)
            dcb.dcbflags &= ~0x0004; dcb.dcbflags |= ((@fOutxCtsFlow & 0x01) << 2)
            dcb.dcbflags &= ~0x0008; dcb.dcbflags |= ((@fOutxDsrFlow & 0x01) << 3)
            dcb.dcbflags &= ~0x0030; dcb.dcbflags |= ((@fDtrControl & 0x03) << 4)
            dcb.dcbflags &= ~0x0040; dcb.dcbflags |= ((@fDsrSensitivity & 0x01) << 6)
            dcb.dcbflags &= ~0x0080; dcb.dcbflags |= ((@fTXContinueOnXoff & 0x01) << 7)
            dcb.dcbflags &= ~0x0100; dcb.dcbflags |= ((@fOutX & 0x01) << 8)
            dcb.dcbflags &= ~0x0200; dcb.dcbflags |= ((@fInX & 0x01) << 9)
            dcb.dcbflags &= ~0x0400; dcb.dcbflags |= ((@fErrorChar & 0x01) << 10)
            dcb.dcbflags &= ~0x0800; dcb.dcbflags |= ((@fNull & 0x01) << 11)
            dcb.dcbflags &= ~0x3000; dcb.dcbflags |= ((@fRtsControl & 0x03) << 12)
            dcb.dcbflags &= ~0x4000; dcb.dcbflags |= ((@fAbortOnError & 0x01) << 14)
            dcb.XonLim = @xonLim
            dcb.XoffLim = @xoffLim
            dcb.ByteSize = @byteSize
            dcb.Parity = @parity
            dcb.StopBits = @stopbit
            dcb.XonChar = @xonchar
            dcb.XoffChar = @xoffchar
            dcb.ErrorChar = @errorchar
            dcb.EofChar = @eofchar
            dcb.EvtChar = @evtchar
            bi = MSKernel32.SetCommState(@iht,dcb)
            throw :exit, -6 if bi == 0
          }
      else
         ir = -1
      end
      return ir
   end

   def escapeCommFunc(ifunc)

      bi = MSKernel32.EscapeCommFunction(@iht,ifunc)
      if bi != 0 then bi = nil end
      return bi
   end

   def close

      bi = MSKernel32.CloseHandle(@iht)
      if bi != 0 then bi = nil end
      return bi
   end

   attr_accessor :comno
   attr_accessor :recbuf
   attr_accessor :senbuf
   attr_accessor :bRate
   attr_accessor :bRate
   attr_accessor :fBinary
   attr_accessor :fParity
   attr_accessor :fOutxCtsFlow
   attr_accessor :fOutxDsrFlow
   attr_accessor :fDtrControl
   attr_accessor :fDsrSensitivity
   attr_accessor :fTXContinueOnXoff
   attr_accessor :fOutX
   attr_accessor :fInX
   attr_accessor :fErrorChar
   attr_accessor :fNull
   attr_accessor :fRtsControl
   attr_accessor :fAbortOnError
   attr_accessor :xonLim
   attr_accessor :xoffLim
   attr_accessor :byteSize
   attr_accessor :parity
   attr_accessor :stopbit
   attr_accessor :xonchar
   attr_accessor :xoffchar
   attr_accessor :errorchar
   attr_accessor :eofchar
   attr_accessor :evtchar
   attr_accessor :readIntervalTimeout
   attr_accessor :readTotalTimeoutMultiplier
   attr_accessor :readTotalTimeoutConstant
   attr_accessor :writeTotalTimeoutMultiplier
   attr_accessor :writeTotalTimeoutConstant
end
