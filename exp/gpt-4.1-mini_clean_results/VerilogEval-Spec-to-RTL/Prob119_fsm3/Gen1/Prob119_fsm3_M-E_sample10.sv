module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

// One-hot state bits
reg A_state, B_state, C_state, D_state;
reg next_A, next_B, next_C, next_D;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        A_state <= 1'b1;
        B_state <= 1'b0;
        C_state <= 1'b0;
        D_state <= 1'b0;
    end else begin
        A_state <= next_A;
        B_state <= next_B;
        C_state <= next_C;
        D_state <= next_D;
    end
end

// Next state logic
always @(*) begin
    // Default next state
    next_A = 1'b0;
    next_B = 1'b0;
    next_C = 1'b0;
    next_D = 1'b0;

    // State transitions according to input
    if (A_state) begin
        next_A = ~in;
        next_B = in;
    end else if (B_state) begin
        next_C = ~in;
        next_B = in;
    end else if (C_state) begin
        next_A = ~in;
        next_D = in;
    end else if (D_state) begin
        next_C = ~in;
        next_B = in;
    end else begin
        // In case of invalid state, reset to A
        next_A = 1'b1;
    end
end

// Output logic (Moore FSM): output=1 only in state D
always @(*) begin
    out = D_state;
end

endmodule