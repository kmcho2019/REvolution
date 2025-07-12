module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Pattern-based ROM implementation
    always @(*) begin
        case (addr)
            8'h00: dout = 16'hA0A0;
            8'h01: dout = 16'hB1B1;
            8'h02: dout = 16'hC2C2;
            8'h03: dout = 16'hD3D3;
            default: begin
                // Algorithmic pattern for remaining addresses:
                // Upper byte = address + 0x80
                // Lower byte = ~address
                dout = {8'h80 + addr[7:0], ~addr[7:0]};
            end
        endcase
    end

    /* Alternative implementation using function:
    function [15:0] rom_lookup;
        input [7:0] a;
        begin
            case (a)
                8'h00: rom_lookup = 16'hA0A0;
                8'h01: rom_lookup = 16'hB1B1;
                8'h02: rom_lookup = 16'hC2C2;
                8'h03: rom_lookup = 16'hD3D3;
                default: rom_lookup = {8'h80 + a, ~a};
            endcase
        end
    endfunction

    assign dout = rom_lookup(addr);
    */

endmodule