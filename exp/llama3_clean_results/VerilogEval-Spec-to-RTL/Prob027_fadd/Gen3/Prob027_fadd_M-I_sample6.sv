module TopModule(
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic cout,
    output logic sum
);

// Continuous assignment for sum and cout to ensure combinational logic
assign sum = a ^ b ^ cin; // XOR operation for sum
assign cout = (a & b) | (a & cin) | (b & cin); // AND and OR operations for carry-out

endmodule