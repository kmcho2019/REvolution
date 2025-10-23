module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output reg out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Next-state logic using ternary operators for minimal logic depth
    always @(*) begin
        next_state = (state == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output registered to reduce glitches and improve timing/power
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;
        else
            out <= state;
    end

endmodule