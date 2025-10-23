module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Decode current state
    wire is_A = y[0];
    wire is_B = y[1];
    wire is_C = y[2];
    wire is_D = y[3];
    wire is_E = y[4];
    wire is_F = y[5];

    // Next state logic for relevant flip-flops
    wire next_Y1 = (is_A & w);               // A->B transition
    wire next_Y3 = (~w) & (is_B | is_C | is_E | is_F);  // Transitions to D

    assign Y1 = next_Y1;
    assign Y3 = next_Y3;

endmodule