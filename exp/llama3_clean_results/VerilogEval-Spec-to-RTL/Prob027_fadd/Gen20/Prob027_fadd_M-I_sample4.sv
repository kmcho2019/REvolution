// Improved Full Adder Module
module FullAdder(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

always @(*) begin
    // Combined expression for sum and carry-out calculations
    {cout, sum} = a + b + cin;
end

endmodule

// Top Module
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