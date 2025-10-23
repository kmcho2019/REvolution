module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic state; // Current state (A=0, B=1)
    logic [1:0] next_state; // Next state

    // Lookup table for next state
    always_comb begin
        case ({state, in})
            2'b00: next_state = 2'b01; // A, in=0 -> B
            2'b01: next_state = 2'b00; // A, in=1 -> A
            2'b10: next_state = 2'b10; // B, in=0 -> B
            2'b11: next_state = 2'b10; // B, in=1 -> B
        endcase
    end

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1; // Asynchronously reset to state B
        end else begin
            state <= next_state[0]; // Update state
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule