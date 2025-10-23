module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding for readability
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Combinational logic to determine next state
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF; // Defensive default
        endcase
    end

    // Sequential logic: state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output directly from state
    assign out = state;

endmodule