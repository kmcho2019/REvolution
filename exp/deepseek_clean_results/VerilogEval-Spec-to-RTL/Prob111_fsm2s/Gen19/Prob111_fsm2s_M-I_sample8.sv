module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    // Optimized state transition logic
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else if (state == OFF)
            state <= j ? ON : OFF;
        else // state == ON
            state <= k ? OFF : ON;
    end

    // Direct output assignment
    assign out = state;

endmodule