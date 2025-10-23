module FullAdder(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

always @(*) begin
    sum = a ^ b ^ cin;
    cout = (a & b) | (a & cin) | (b & cin);
end

endmodule

module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

FullAdder fa(
    .a(a),
    .b(b),
    .cin(cin),
    .cout(cout),
    .sum(sum)
);

endmodule