module TopModule (
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

    // Combinational next state logic using a case statement for clarity
    always @(*) begin
        case(state)
            OFF: next_state = (j) ? ON : OFF;
            ON : next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output as simple continuous assignment from state (ON = 1, OFF = 0)
    assign out = (state == ON);

endmodule