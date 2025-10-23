module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

assign out_assign = a & b;

reg internal_out;
always @(*) begin
    internal_out = a & b;
end

assign out_alwaysblock = internal_out;

endmodule