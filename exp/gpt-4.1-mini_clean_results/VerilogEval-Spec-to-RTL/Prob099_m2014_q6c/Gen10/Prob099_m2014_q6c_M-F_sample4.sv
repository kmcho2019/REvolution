module TopModule (
    input  [5:0] y,  // one-hot encoded current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1,
    output       Y2,
    output       Y3,
    output       Y4
);

    // Alias state bits for readability
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Compute next-state bit Y2 (next state's B bit)
    assign Y2 = A & ~w;

    // Compute next-state bit Y4 (next state's D bit)
    assign Y4 = w & (B | C | E | F);

    // Tie Y1 and Y3 to zero as no logic specified
    assign Y1 = 1'b0;
    assign Y3 = 1'b0;

endmodule