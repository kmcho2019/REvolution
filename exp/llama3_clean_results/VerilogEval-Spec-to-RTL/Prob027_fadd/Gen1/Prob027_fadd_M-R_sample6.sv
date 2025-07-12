module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

wire half_sum;
wire half_cout;

assign half_sum = a ^ b;
assign half_cout = a & b;

assign sum = half_sum ^ cin;
assign cout = half_cout | (half_sum & cin);

endmodule