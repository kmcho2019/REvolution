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
            state <= (state == 0) ? ~in : in; // Simplified next state logic
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule