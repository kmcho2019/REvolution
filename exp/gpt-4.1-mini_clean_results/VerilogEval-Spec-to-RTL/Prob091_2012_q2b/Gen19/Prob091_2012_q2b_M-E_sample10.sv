module TopModule(
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

    always @(*) begin
        // Default outputs
        Y1 = 1'b0;
        Y3 = 1'b0;

        // Next input for state B (y[1])
        if (y[0] && w)
            Y1 = 1'b1;

        // Next input for state D (y[3])
        if (~w && (y[1] || y[2] || y[3] || y[4] || y[5]))
            Y3 = 1'b1;
    end

endmodule