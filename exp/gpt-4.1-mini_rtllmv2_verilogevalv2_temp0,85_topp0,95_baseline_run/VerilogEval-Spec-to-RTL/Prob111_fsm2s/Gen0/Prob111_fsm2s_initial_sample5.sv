module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding
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

    // Output logic (Moore machine)
    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule