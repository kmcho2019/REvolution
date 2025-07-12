module TopModule(
    input  a,
    input  b,
    input  c,
    output out
);

always @(*) begin
    out = (a == 1'b1) || (b == 1'b1) || (c == 1'b1);
end

endmodule