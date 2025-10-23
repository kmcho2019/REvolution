module TopModule (
    input  [5:0] y,  // one-hot encoded current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // unused by problem but declared in interface - will drive 0
    output       Y3  // unused by problem but declared in interface - will drive 0
);

    // Alias state bits for readability
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Compute next-state bit Y2 (next state's B bit)
    wire Y2 = A & ~w;

    // Compute next-state bit Y4 (next state's D bit)
    wire Y4 = w & (B | C | E | F);

    // The problem states outputs Y1 and Y3, but logic is not specified for them.
    // To avoid leaving them floating, tie them to 0.
    assign Y1 = 1'b0;
    assign Y3 = 1'b0;

endmodule