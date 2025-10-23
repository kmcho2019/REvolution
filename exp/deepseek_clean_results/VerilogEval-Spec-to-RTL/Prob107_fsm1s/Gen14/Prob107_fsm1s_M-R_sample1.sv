module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions
    parameter STATE_B = 1'b0;
    parameter STATE_A = 1'b1;

    // State storage
    reg state;
    wire next_state;

    // Next state logic (combinational)
    assign next_state = state ? in : ~in;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= STATE_B;
        else
            state <= next_state;
    end

    // Output logic (combinational)
    assign out = (state == STATE_B);

endmodule