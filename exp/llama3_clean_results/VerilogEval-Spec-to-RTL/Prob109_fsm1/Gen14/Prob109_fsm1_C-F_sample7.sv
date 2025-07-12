module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic state; // Current state (A=0, B=1)

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronously reset to state B
            state <= 1'b1;
        end else begin
            // Use ternary operator to concisely express state transitions
            // Reflecting the state machine transitions: B(1) --0--> A, B(1) --1--> B, A(0) --0--> B, A(0) --1--> A
            state <= (state == 1'b1)? (in? 1'b1 : 1'b0) : (in? 1'b0 : 1'b1);
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule