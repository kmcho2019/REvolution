// Full Adder Module
module FullAdder(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

// Efficient calculation of sum and carry-out
always @(*) begin
    // Sum calculation remains the same for a full adder
    sum = a ^ b ^ cin;
    // Carry-out calculation: Factorization or simplification doesn't significantly reduce complexity
    cout = (a & b) | (a & cin) | (b & cin);
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