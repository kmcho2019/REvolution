module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    casex(in)
        4'b1xxx: pos = 2'b11;  // in[3] is set
        4'b01xx: pos = 2'b10;  // in[2] is set
        4'b001x: pos = 2'b01;  // in[1] is set
        4'b0001: pos = 2'b00;  // in[0] is set
        default: pos = 2'b00;  // no bits set
    endcase
end

endmodule