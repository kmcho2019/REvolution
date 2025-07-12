module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding for clarity and maintainability
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    reg next_state;

    // Next-state combinational logic using always @(*) and case for clarity
    always @(*) begin
        case(state)
            OFF: next_state = j ? ON  : OFF;
            ON:  next_state = k ? OFF : ON;
            default: next_state = OFF; // Safe fallback
        endcase
    end

    // Synchronous state update with active-high reset, non-blocking assignment
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output derived solely from current state
    assign out = (state == ON);

endmodule