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
    reg next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            OFF: next_state = (j) ? ON : OFF;
            ON : next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register with asynchronous active-high reset, no clock enable gating
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic (Moore output is state itself)
    assign out = state;

endmodule