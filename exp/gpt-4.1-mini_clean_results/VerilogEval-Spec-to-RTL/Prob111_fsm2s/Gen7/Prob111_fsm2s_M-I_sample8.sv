module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State encoding for readability
    localparam OFF = 1'b0, ON = 1'b1;
    reg state;

    // Combinational next state logic
    wire next_state = (state == OFF) ? (j ? ON : OFF)
                                   : (k ? OFF : ON);

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Registered Moore output to reduce glitches and switching power
    always @(posedge clk) begin
        if (reset)
            out <= 1'b0;
        else
            out <= (state == ON);
    end

endmodule