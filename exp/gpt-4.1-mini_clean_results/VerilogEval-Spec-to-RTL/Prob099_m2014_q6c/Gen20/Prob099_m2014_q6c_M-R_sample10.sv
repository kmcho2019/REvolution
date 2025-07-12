module TopModule(
    input  [5:0] y,  // one-hot encoded current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output reg   Y2, // next-state bit corresponding to B (y[1])
    output reg   Y4  // next-state bit corresponding to D (y[3])
);

    // Define named constants for clarity
    localparam A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;

    always @* begin
        // Initialize outputs
        Y2 = 1'b0;
        Y4 = 1'b0;

        // Next state B occurs only when in A and w=0
        if (y[A] && ~w)
            Y2 = 1'b1;

        // Next state D occurs when w=1 and current state is B, C, E, or F
        if (w && (y[B] || y[C] || y[E] || y[F]))
            Y4 = 1'b1;
    end

endmodule