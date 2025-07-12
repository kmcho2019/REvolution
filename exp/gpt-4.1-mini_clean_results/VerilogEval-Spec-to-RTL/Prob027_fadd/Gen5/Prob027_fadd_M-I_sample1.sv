module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

wire w1;

assign w1 = a ^ b;         // half sum
assign sum = w1 ^ cin;     // final sum
assign cout = (a & b) | (cin & w1);  // carry out

endmodule