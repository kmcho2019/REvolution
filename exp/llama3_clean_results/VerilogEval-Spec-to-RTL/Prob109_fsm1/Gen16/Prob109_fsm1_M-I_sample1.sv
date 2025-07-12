module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic state; // Current state (A=0, B=1)
    logic next_state; // Next state based on current state and input

    // Combinational logic for next state, simplified for low power
    always @(*) begin
        case (state)
            0: next_state = ~in; // Simplified logic for state A
            1: next_state = in;  // Simplified logic for state B
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