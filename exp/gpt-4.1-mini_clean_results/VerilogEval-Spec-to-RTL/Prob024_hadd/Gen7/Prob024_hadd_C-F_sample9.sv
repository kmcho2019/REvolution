module TopModule (
    input  a,
    input  b,
    output wire sum,
    output wire cout
);

assign sum = a ^ b;
assign cout = a & b;

endmodule