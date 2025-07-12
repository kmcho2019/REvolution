module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    // State register with asynchronous reset and direct next state logic
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else if (state == OFF)
            state <= j ? ON : OFF;
        else // state == ON
            state <= k ? OFF : ON;
    end

    // Output logic (Moore)
    assign out = state;

endmodule