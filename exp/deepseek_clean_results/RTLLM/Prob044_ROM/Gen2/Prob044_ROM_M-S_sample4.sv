module ROM (
    input [7:0] addr,
    output reg [15:0] dout
);

    // Direct case statement for the 4 required values
    always @(*) begin
        case (addr[1:0])  // Only need to check 2 LSBs
            2'b00: dout = 16'hA0A0;
            2'b01: dout = 16'hB1B1;
            2'b10: dout = 16'hC2C2;
            2'b11: dout = 16'hD3D3;
            default: dout = 16'h0000;
        endcase
    end

endmodule