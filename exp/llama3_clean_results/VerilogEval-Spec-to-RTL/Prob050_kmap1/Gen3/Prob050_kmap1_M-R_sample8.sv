module TopModule(
    input a,
    input b,
    input c,
    output out
);

reg out_reg;
reg a_or_b_or_c;

always @(*) begin
    a_or_b_or_c = b | c;
    out_reg = (a) | (a_or_b_or_c & ~a);
end

assign out = out_reg;

endmodule