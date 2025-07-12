// Full Adder Module
module FullAdder(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Direct and efficient calculation of sum and carry-out
// The equations are already optimized for a full adder.
assign sum = a ^ b ^ cin; // Sum is the XOR of all inputs.
assign cout = (a & b) | (a & cin) | (b & cin); // Carry-out is generated when any two inputs are high.

endmodule

// Top Module
module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Instantiating the FullAdder module within TopModule.
FullAdder fa(
   .a(a),
   .b(b),
   .cin(cin),
   .cout(cout),
   .sum(sum)
);

endmodule