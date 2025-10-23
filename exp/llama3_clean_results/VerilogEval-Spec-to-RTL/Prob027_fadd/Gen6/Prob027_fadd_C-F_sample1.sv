module HalfAdder(
    input a,
    input b,
    output reg sum,
    output reg cout
);

always @(*) begin
    sum = a ^ b;
    cout = a & b;
end

endmodule

module TopModule(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

wire ha1_sum;
wire ha1_cout;
wire ha2_sum;
wire ha2_cout;

HalfAdder ha1(
   .a(a),
   .b(b),
   .sum(ha1_sum),
   .cout(ha1_cout)
);

HalfAdder ha2(
   .a(ha1_sum),
   .b(cin),
   .sum(sum),
   .cout(ha2_cout)
);

always @(*) begin
    cout = ha1_cout | ha2_cout;
end

endmodule