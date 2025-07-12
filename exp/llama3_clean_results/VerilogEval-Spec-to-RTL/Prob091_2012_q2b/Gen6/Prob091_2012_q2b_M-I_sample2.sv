module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Define the state conditions explicitly
wire is_A = y[0];
wire is_B = y[1];
wire is_C = y[2];
wire is_D = y[3];
wire is_E = y[4];
wire is_F = y[5];

// Assign Y1 based on the transition from A to B
assign Y1 = is_A && w;

// Simplify the condition for Y3
wire is_Y3_state = is_B || is_C || is_E || is_F;
assign Y3 = is_Y3_state &&!w;

endmodule