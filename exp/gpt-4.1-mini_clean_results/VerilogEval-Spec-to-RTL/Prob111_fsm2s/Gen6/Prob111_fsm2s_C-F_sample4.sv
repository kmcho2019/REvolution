module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding for readability
    localparam OFF = 1'b0, ON = 1'b1;
    reg state;

    // Combinational next state logic
    wire next_state = (state == OFF) ? (j ? ON : OFF)
                                   : (k ? OFF : ON);

    // Moore output depends only on current state
    assign out = (state == ON);

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

endmodule