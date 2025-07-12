module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    always @(*) begin
        case (addr)
            8'h00: dout = 16'hA0A0;
            8'h01: dout = 16'hB1B1;
            8'h02: dout = 16'hC2C2;
            8'h03: dout = 16'hD3D3;
            // Default case for uninitialized addresses
            default: dout = 16'h0000;
        endcase
    end

    // Alternative implementation using function
    // assign dout = rom_lookup(addr);
    // 
    // function [15:0] rom_lookup(input [7:0] addr);
    //     case (addr)
    //         8'h00: rom_lookup = 16'hA0A0;
    //         8'h01: rom_lookup = 16'hB1B1;
    //         8'h02: rom_lookup = 16'hC2C2;
    //         8'h03: rom_lookup = 16'hD3D3;
    //         default: rom_lookup = 16'h0000;
    //     endcase
    // endfunction

endmodule