// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Intermediate signals to break down the XOR operation
    logic ab_xored;  // XOR of a and b
    logic abc_xored;  // XOR of (a XOR b) and c
    logic abcd_xored;  // XOR of ((a XOR b) XOR c) and d

    // Calculate XOR of a and b
    assign ab_xored = (a && !b) || (!a && b);

    // Calculate XOR of (a XOR b) and c
    assign abc_xored = (ab_xored && !c) || (!ab_xored && c);

    // Calculate XOR of ((a XOR b) XOR c) and d
    assign abcd_xored = (abc_xored && !d) || (!abc_xored && d);

    // The output q is the inverse of the final XOR result
    assign q = !abcd_xored;

endmodule