module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Generate difference vector (1 where A > B at each bit position)
wire [2:0] diff = A & ~B;

// Generate equality vector (1 where A == B at each bit position)
wire [2:0] eq = ~(A ^ B);

// Create thermometer code for magnitude comparison
wire [6:0] therm_code;
assign therm_code[0] = eq[2] & eq[1] & eq[0];  // All bits equal
assign therm_code[1] = diff[0] & eq[2] & eq[1]; // LSB greater
assign therm_code[2] = diff[1] & eq[2];        // Middle bit greater
assign therm_code[3] = diff[2];                // MSB greater
assign therm_code[6:4] = 3'b0;                  // Unused codes

// Priority encoder for thermometer code
wire any_gt = |therm_code[3:1];
wire any_lt = ~(&eq) & ~any_gt;

// Output assignment with mutual exclusivity
assign A_greater = any_gt;
assign A_equal = therm_code[0];
assign A_less = any_lt;

endmodule