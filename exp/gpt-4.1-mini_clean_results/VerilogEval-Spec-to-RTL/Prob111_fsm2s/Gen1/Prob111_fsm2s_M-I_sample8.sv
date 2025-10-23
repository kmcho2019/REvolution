module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding using localparams and single-bit reg
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Registered output (Moore output depends on current state)
    always @(posedge clk) begin
        if (reset)
            out <= 1'b0;
        else
            out <= (state == ON) ? 1'b1 : 1'b0;
    end

endmodule