module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate signals for conditions
wire same_c_d;
wire diff_a_b;
wire same_a_b;
wire diff_c_d;

// Assign conditions to intermediate signals
assign same_c_d = (c == d);
assign diff_a_b = (a != b);
assign same_a_b = (a == b);
assign diff_c_d = (c != d);

// Combine conditions to generate output
assign out = (same_c_d & diff_a_b) | (diff_c_d & same_a_b);

endmodule