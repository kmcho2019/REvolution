module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output reg   Y2, // next state signal corresponding to y[1] (state B)
    output reg   Y4  // next state signal corresponding to y[3] (state D)
);

    always @(*) begin
        // Default outputs to 0
        Y2 = 1'b0;
        Y4 = 1'b0;

        // Derive Y2 (next y[1]) logic by inspection from transitions:
        // B active only when A=1 & w=0
        if (y[0] && ~w)
            Y2 = 1'b1;

        // Derive Y4 (next y[3]) logic by inspection from transitions:
        // D active when (B or C or D or E or F) and w=1
        if (w && (y[1] || y[2] || y[3] || y[4] || y[5]))
            Y4 = 1'b1;
    end

endmodule