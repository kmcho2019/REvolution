module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // Current state (A=0, B=1)
    logic state;

    // Combinational logic for next state, simplified for low power
    logic next_state;
    always_comb begin
        case (state)
            1'b0: next_state = ~in; // Simplified logic for state A
            1'b1: next_state = in;  // Simplified logic for state B
            default: next_state = 1'b1; // Default to state B for any other state
        endcase
    end

    // Sequential logic with asynchronous reset, optimized for timing
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1; // Asynchronously reset to state B
        end else begin
            state <= next_state; // Update state on clock edge
        end
    end

    // Directly assign output based on the state for minimal area
    assign out = state;

endmodule