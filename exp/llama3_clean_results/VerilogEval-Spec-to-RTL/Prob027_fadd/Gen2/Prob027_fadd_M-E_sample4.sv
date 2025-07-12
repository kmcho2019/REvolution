module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Half adder logic
wire sum_ab;
wire cout_ab;

assign sum_ab = a ^ b;
assign cout_ab = a & b;

// Second half adder to include cin
assign sum = sum_ab ^ cin;
assign cout = (sum_ab & cin) | cout_ab;

endmodule