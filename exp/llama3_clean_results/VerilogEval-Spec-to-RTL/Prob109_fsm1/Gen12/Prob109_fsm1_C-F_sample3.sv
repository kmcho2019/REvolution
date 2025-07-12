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
            state <= 1; // Asynchronously reset to state B
        end else begin
            // Simplify next state logic using XOR with inverted input
            state <= state ^ (~in);
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule