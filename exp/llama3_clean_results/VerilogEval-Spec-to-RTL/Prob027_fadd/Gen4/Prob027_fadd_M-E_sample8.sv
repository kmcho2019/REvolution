module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

wire p, g;
assign p = a ^ b;
assign g = (a & b) | (a & cin) | (b & cin);
assign sum = p ^ cin;
assign cout = g;

endmodule