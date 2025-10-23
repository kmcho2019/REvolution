module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Combined next state logic and output assignment
    always @(*) begin
        // Next state logic
        if (state == B)
            next_state = (in == 1'b0) ? A : B;
        else // state == A
            next_state = (in == 1'b0) ? B : A;

        // Output depends only on state
        out = (state == B) ? 1'b1 : 1'b0;
    end

endmodule