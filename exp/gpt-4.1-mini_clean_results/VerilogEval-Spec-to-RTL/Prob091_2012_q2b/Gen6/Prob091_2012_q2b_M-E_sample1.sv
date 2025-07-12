module TopModule (
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

    always @(*) begin
        // Default outputs to 0
        Y1 = 1'b0;
        Y3 = 1'b0;

        // Y1: next state B (y[1]) = y[0] & w
        if (y[0] && w)
            Y1 = 1'b1;

        // Y3: next state D (y[3]) = (y[1] | y[2] | y[4] | y[5]) & ~w
        if ((y[1] || y[2] || y[4] || y[5]) && ~w)
            Y3 = 1'b1;
    end

endmodule