module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding using typedef enum for clarity and maintainability
    typedef enum logic {
        B = 1'b0,
        A = 1'b1
    } state_t;

    state_t state, next_state;

    // Next state combinational logic
    always @(*) begin
        if (state == B)
            next_state = (in == 1'b0) ? A : B;
        else // state == A
            next_state = (in == 1'b0) ? B : A;
    end

    // Sequential state register with synchronous active-high reset
    // Ensure reset is well-timed to avoid unintended reset holds
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output depends only on current state
    assign out = (state == B);

endmodule