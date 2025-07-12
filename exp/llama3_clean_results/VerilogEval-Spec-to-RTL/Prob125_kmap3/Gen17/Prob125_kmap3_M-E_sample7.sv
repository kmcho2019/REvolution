module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Don't-care input
    output out
);

// First, evaluate the condition when 'a' is 1
wire a_condition = a;

// Then, evaluate the condition when 'a' is 0, 'b' is 0, and 'c' is 1
wire bc_condition = ~a & ~b & c;

// Combine the conditions to produce the final output
assign out = a_condition | bc_condition;

endmodule