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
            default: dout = 16'h0000;
        endcase
    end

endmodule