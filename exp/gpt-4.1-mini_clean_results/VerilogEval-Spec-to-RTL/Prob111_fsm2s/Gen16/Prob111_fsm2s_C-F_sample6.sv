module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding for clarity
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else if (state == OFF)
            state <= j ? ON : OFF;
        else // state == ON
            state <= k ? OFF : ON;
    end

    assign out = (state == ON);

endmodule