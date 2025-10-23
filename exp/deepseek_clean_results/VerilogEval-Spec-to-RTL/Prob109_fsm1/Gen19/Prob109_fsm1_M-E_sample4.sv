module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // 2-bit shift register for state encoding
    // [1] is current state, [0] is previous state (not used in this implementation)
    reg [1:0] state_reg;

    // Shift register update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_reg <= 2'b11; // Reset to state B (1)
        end
        else begin
            // Shift in new state based on current state and input
            state_reg <= {state_reg[0], 
                         (state_reg[1] ? (in ? 1'b1 : 1'b0) : 
                                         (in ? 1'b0 : 1'b1))};
        end
    end

    // Output is the current state (MSB of shift register)
    assign out = state_reg[1];

endmodule