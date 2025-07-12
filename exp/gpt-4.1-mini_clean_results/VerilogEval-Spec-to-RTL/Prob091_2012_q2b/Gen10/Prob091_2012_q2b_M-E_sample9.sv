module TopModule (
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

    always @(*) begin
        // Default outputs
        Y1 = 1'b0;
        Y3 = 1'b0;

        // Y1 is next input for y[1] (state B)
        // Transition: A (y[0]) --1--> B
        if (y[0] && w)
            Y1 = 1'b1;

        // Y3 is next input for y[3] (state D)
        // Transitions: B (y[1]), C (y[2]), E (y[4]), F (y[5]) --0--> D
        if ((y[1] || y[2] || y[4] || y[5]) && ~w)
            Y3 = 1'b1;
    end

endmodule