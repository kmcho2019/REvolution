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
        case (state)
            0: next_state = in ? 0 : 1; // State A transitions
            1: next_state = in ? 1 : 0; // State B transitions
            default: next_state = 1; // Default to state B
        endcase
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