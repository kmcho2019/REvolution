module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    // Next state logic as continuous assignment using conditional operators
    wire next_state = (state == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);

    // State update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output directly from current state
    assign out = state;

endmodule