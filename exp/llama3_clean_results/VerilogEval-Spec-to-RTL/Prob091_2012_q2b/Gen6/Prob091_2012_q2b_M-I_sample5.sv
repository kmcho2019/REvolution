module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Define the state conditions explicitly for better readability
wire is_A = y[0];
wire is_B = y[1];
wire is_C = y[2];
wire is_D = y[3];
wire is_E = y[4];
wire is_F = y[5];

// Calculate the inverted w signal only once to reduce switching activity
wire not_w = ~w;

// Assign Y1 based on the transition from A to B
assign Y1 = is_A && w;

// Assign Y3 based on transitions to D, using the pre-calculated not_w
assign Y3 = (is_B && not_w) || (is_C && not_w) || (is_E && not_w) || (is_F && not_w);

endmodule