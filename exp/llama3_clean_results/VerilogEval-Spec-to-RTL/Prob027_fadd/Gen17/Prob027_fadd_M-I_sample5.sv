// Full Adder Module
module FullAdder(
    input  logic a,    // Input a
    input  logic b,    // Input b
    input  logic cin,  // Carry-in
    output logic cout, // Carry-out
    output logic sum   // Sum
);

// Direct and efficient calculation of sum and carry-out
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

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