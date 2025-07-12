// Improved Full Adder Module for better PPA
module TopModule(
    input  logic a,    // Input a
    input  logic b,    // Input b
    input  logic cin,  // Carry-in
    output logic cout, // Carry-out
    output logic sum   // Sum
);

// Direct and efficient calculation of sum and carry-out
// This logic is already optimized for a full adder
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule