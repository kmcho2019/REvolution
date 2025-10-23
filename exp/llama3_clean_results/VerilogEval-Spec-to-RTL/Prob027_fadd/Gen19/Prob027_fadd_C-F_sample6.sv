// Full Adder Module
module FullAdder(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

always @(*) begin
    sum = a ^ b ^ cin; // Efficient calculation of sum
    cout = (a & b) | (a & cin) | (b & cin); // Efficient calculation of carry-out
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