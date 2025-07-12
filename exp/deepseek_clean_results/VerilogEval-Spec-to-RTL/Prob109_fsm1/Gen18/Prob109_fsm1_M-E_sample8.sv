module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // 2-bit shift register: [1] = next state, [0] = current state
    reg [1:0] state_shift;

    // Next state computation (combinational)
    wire next_state = areset ? 1'b1 : 
                     (state_shift[0] ? (in ? 1'b1 : 1'b0) :  // Current state B
                     (in ? 1'b0 : 1'b1);                     // Current state A

    // State update (shift register behavior)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state_shift <= 2'b11;  // Reset to state B (current=1, next=1)
        else
            state_shift <= {next_state, state_shift[1]};
    end

    // Output is current state bit
    assign out = state_shift[0];

endmodule