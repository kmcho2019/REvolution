module TopModule (
    input [3:0] in,
    output [1:0] pos
);

always @(*) begin
    casex (in)
        4'b1xxx: pos = 2'b11; // in[3] is 1
        4'b01xx: pos = 2'b10; // in[2] is 1
        4'b001x: pos = 2'b01; // in[1] is 1
        4'b0001: pos = 2'b00; // in[0] is 1
        default: pos = 2'b00; // all zeros
    endcase
end

endmodule