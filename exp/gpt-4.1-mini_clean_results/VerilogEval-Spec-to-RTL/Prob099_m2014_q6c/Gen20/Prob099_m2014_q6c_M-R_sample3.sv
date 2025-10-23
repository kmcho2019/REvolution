module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output reg   Y2, // next state bit corresponding to B (y[1])
    output reg   Y4  // next state bit corresponding to D (y[3])
);

    always @(*) begin
        // Default outputs
        Y2 = 1'b0;
        Y4 = 1'b0;

        // Next state B (y[1]) is set only when current state is A (y[0]) and input w=0
        if (y[0] && ~w)
            Y2 = 1'b1;

        // Next state D (y[3]) is set if current state is one of B, C, E, F and w=1
        if (w && (y[1] || y[2] || y[4] || y[5]))
            Y4 = 1'b1;
    end

endmodule