module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg state, next_state;
    localparam OFF = 1'b0, ON = 1'b1;

    // Combinational next state logic using case statement for clarity and optimization
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON : next_state = k ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    assign out = state;

endmodule