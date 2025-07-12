module ROM (
    input  wire [7:0]  addr,
    output wire [15:0] dout
);

    // Combinational function implementing ROM content using a case statement
    function [15:0] rom_lookup;
        input [7:0] address;
        begin
            case (address)
                8'h00: rom_lookup = 16'hA0A0;
                8'h01: rom_lookup = 16'hB1B1;
                8'h02: rom_lookup = 16'hC2C2;
                8'h03: rom_lookup = 16'hD3D3;
                // All other addresses default to zero
                default: rom_lookup = 16'h0000;
            endcase
        end
    endfunction

    assign dout = rom_lookup(addr);

endmodule