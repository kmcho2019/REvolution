module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // Pattern generation function
    function [15:0] rom_pattern;
        input [7:0] address;
        begin
            // Custom pattern algorithm:
            // Upper byte: (address XOR 0xAA) rotated right by 2 bits
            // Lower byte: (address + 0x55) modulo 256
            rom_pattern = {((address ^ 8'hAA) >> 2) | ((address ^ 8'hAA) << 6), 
                          (address + 8'h55)};
        end
    endfunction

    // Continuous read operation with generated pattern
    assign dout = rom_pattern(addr);

endmodule