module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

reg [3:0] q_reg;

always @(*) begin
    case (c)
        4'b0000: q_reg = b;
        4'b0001: q_reg = e;
        4'b0010: q_reg = a;
        4'b0011: q_reg = d;
        default: q_reg = 4'b1111;
    endcase
end

assign q = q_reg;

endmodule