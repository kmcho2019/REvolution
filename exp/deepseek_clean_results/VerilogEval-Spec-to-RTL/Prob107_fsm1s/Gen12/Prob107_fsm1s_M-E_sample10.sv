module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // 2-bit shift register for state representation
    reg [1:0] state_reg;

    // Shift register operation
    always @(posedge clk) begin
        if (reset) begin
            state_reg <= 2'b10;  // Reset to state B ("10")
        end else begin
            // Shift operation: MSB becomes current state, LSB becomes next state
            state_reg <= {state_reg[0], 
                          state_reg[1] ? (in ? 1'b1 : 1'b0) :  // Current state B
                                        (in ? 1'b1 : 1'b0)};   // Current state A
        end
    end

    // Output is simply the MSB of the shift register
    assign out = state_reg[1];

endmodule