module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

assign out_assign = a & b;
reg out_alwaysblock;
always @(*) begin
    out_alwaysblock = a & b;
end

endmodule