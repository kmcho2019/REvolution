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
    case (c[1:0])
        2'b00: q_reg = b;
        2'b01: q_reg = e;
        2'b10: q_reg = a;
        2'b11: q_reg = d;
        default: q_reg = 4'b1111;
    endcase

    if (c[3:2]!= 2'b00) begin
        q_reg = 4'b1111;
    end
end

assign q = q_reg;

endmodule