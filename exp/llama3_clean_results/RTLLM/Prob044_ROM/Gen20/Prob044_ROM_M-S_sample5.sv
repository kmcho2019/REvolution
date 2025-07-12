module ROM(
    input [7:0] addr,
    output [15:0] dout
);

always @(*) begin
    case (addr)
        8'h0: dout = 16'hA0A0;
        8'h1: dout = 16'hB1B1;
        8'h2: dout = 16'hC2C2;
        8'h3: dout = 16'hD3D3;
        default: dout = 16'h0; // default value for undefined addresses
    endcase
end

endmodule