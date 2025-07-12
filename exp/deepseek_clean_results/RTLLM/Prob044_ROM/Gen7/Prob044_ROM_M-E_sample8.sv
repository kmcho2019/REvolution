module ROM (
    input [7:0] addr,
    output [15:0] dout
);

    // ROM implemented as a function with case statement
    function [15:0] rom_lookup;
        input [7:0] address;
        begin
            case(address)
                8'h00: rom_lookup = 16'hA0A0;
                8'h01: rom_lookup = 16'hB1B1;
                8'h02: rom_lookup = 16'hC2C2;
                8'h03: rom_lookup = 16'hD3D3;
                default: rom_lookup = 16'h0000; // Default value for all other addresses
            endcase
        end
    endfunction

    // Continuous output assignment using the lookup function
    assign dout = rom_lookup(addr);

endmodule