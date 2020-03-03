txt = "12345"
txt = ARGV[0] if ARGV[0] =~ /^[0-9A-Fa-f]+$/
# puts "#{txt}/#{txt.to_i(16)}"

POLY = 0b1011
pol_size = POLY.to_s(2).size - 1
val_raw = txt.to_i(16) << pol_size
val_raw = 0b11010011101100 << pol_size

crc = val_raw
crc_len = crc.to_s(2).size
printf("[CRC]%020b\n", crc)
while crc > POLY
    tmp = crc ^ (POLY << crc_len)
    if ( tmp.to_s(2).length < crc.to_s(2).length )
        crc = tmp
        printf("[POL]%020b\n", (POLY << crc_len))
        printf("[CRC]%020b\n", crc)
    end
    crc_len = crc_len - 1
end
puts sprintf("%04b",crc)