module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    reg B_state, A_state;

    // State flip-flops with synchronous reset and explicit next state logic
    always @(posedge clk) begin
        if (reset) begin
            B_state <= 1'b1;  // Reset to B
            A_state <= 1'b0;
        end else begin
            // Next state logic:
            // From B: if in==0 go to A; else stay B
            // From A: if in==0 go to B; else stay A
            B_state <= (B_state & in) | (A_state & ~in);
            A_state <= (B_state & ~in) | (A_state & in);
        end
    end

    // Output is 1 when in state B (one-hot encoding)
    assign out = B_state;

endmodule