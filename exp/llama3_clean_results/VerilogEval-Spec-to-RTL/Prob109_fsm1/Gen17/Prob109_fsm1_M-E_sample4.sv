module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic state; // Current state (A=0, B=1)

    // Single always block for combinational and sequential logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronously reset to state B
            state <= 1'b1;
        end else begin
            // Directly update state based on current state and input
            state <= (~state & ~in) | (state & in);
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule