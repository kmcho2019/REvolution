module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding:
    // B = 0, output = 1
    // A = 1, output = 0

    reg state;
    reg next_state;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            1'b0: next_state = ~in;  // B state: if in=0->A(1), else B(0)
            1'b1: next_state = in;   // A state: if in=0->B(0), else A(1)
            default: next_state = 1'b0;
        endcase
    end

    // State register with synchronous active-high reset, update only if changed
    always @(posedge clk) begin
        if (reset)
            state <= 1'b0;  // B state
        else if (next_state != state)
            state <= next_state;
    end

    // Output logic: output is 1 when in B (state=0), else 0
    assign out = ~state;

endmodule