module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Shift register implementation
    // [1] represents current state (1 for B, 0 for A)
    // [0] represents previous state (not used but maintained for symmetry)
    reg [1:0] state_reg;

    // Next state logic implemented via shift
    wire next_bit = areset ? 1'b1 : 
                   (state_reg[1] ? in : ~in);

    // State register update with shift operation
    always @(posedge clk or posedge areset) begin
        if (areset)
            state_reg <= 2'b11; // Initialize to state B
        else
            state_reg <= {next_bit, state_reg[1]};
    end

    // Output is simply the MSB of the shift register
    assign out = state_reg[1];

endmodule