module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

wire ha1_sum;
wire ha1_cout;
wire ha2_sum;
wire ha2_cout;

assign ha1_sum = a ^ b;
assign ha1_cout = a & b;

assign ha2_sum = ha1_sum ^ cin;
assign ha2_cout = ha1_sum & cin;

assign sum = ha2_sum;
assign cout = ha1_cout | ha2_cout;

endmodule