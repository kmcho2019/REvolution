module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

wire p, g;

assign p = a ^ b;
assign g = a & b;

assign sum = p ^ cin;
assign cout = g | (p & cin);

endmodule