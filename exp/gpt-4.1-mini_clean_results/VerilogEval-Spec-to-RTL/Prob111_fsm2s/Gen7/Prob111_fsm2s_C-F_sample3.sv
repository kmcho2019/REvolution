module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State encoding with localparams for clarity
    localparam OFF = 1'b0, ON = 1'b1;

    reg state, next_state;

    // Combinational next state logic
    always @(*) begin
        case(state)
            OFF: next_state = (j) ? ON : OFF;
            ON:  next_state = (k) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Sequential state update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Combinational Moore output logic depending only on the registered state
    always @(*) begin
        case(state)
            OFF: out = 1'b0;
            ON:  out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule