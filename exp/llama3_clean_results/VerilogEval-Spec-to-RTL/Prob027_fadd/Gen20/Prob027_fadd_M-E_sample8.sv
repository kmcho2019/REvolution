// Half Adder Module
module HalfAdder(
    input  logic a,    // Input a
    input  logic b,    // Input b
    output logic sum,  // Sum
    output logic cout  // Carry-out
);

// Direct and efficient calculation of sum and carry-out
assign sum = a ^ b;
assign cout = a & b;

endmodule

// Full Adder Module using Half Adders
module FullAdder(
    input  logic a,    // Input a
    input  logic b,    // Input b
    input  logic cin,  // Carry-in
    output logic cout, // Carry-out
    output logic sum   // Sum
);

// Instantiate two Half Adder modules
logic ha1_sum, ha1_cout, ha2_sum, ha2_cout;

HalfAdder ha1(
    .a(a),     // Input a
    .b(b),     // Input b
    .sum(ha1_sum),  // Sum
    .cout(ha1_cout) // Carry-out
);

HalfAdder ha2(
    .a(ha1_sum), // Sum of first half adder
    .b(cin),     // Carry-in
    .sum(sum),   // Final Sum
    .cout(cout)  // Final Carry-out
);

// The carry-out of the full adder is directly taken from the second half adder

endmodule

// Top Module
module TopModule(
    input  logic a,    // Input a
    input  logic b,    // Input b
    input  logic cin,  // Carry-in
    output logic cout, // Carry-out
    output logic sum   // Sum
);

// Instantiate the FullAdder module
FullAdder fa(
    .a(a),     // Input a
    .b(b),     // Input b
    .cin(cin), // Carry-in
    .cout(cout), // Carry-out
    .sum(sum)   // Sum
);

endmodule