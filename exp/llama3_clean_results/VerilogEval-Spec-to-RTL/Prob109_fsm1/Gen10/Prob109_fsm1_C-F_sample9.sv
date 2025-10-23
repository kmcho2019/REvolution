module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic state; // Current state (A=0, B=1)
    logic next_state; // Next state

    // Combinational logic
    always_comb begin
        next_state = (state == 0) ? ~in : in; // Simplified state transition logic
    end

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1; // Asynchronously reset to state B
        end else begin
            state <= next_state; // Update state on clock edge
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule