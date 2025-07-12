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
    wire next_state;

    // Combinational next-state logic using ternary operators for succinctness
    assign next_state = (state == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);

    // Moore output depends only on current state
    assign out = (state == ON);

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

endmodule