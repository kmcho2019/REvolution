module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Assign one-hot codes to each state
wire state_A = y[0];
wire state_B = y[1];
wire state_C = y[2];
wire state_D = y[3];
wire state_E = y[4];
wire state_F = y[5];

// Logic equation for Y1
assign Y1 = (~w & state_A) | (w & state_B);

// Logic equation for Y3
assign Y3 = (w & (state_B | state_C)) | (~w & state_D);

endmodule