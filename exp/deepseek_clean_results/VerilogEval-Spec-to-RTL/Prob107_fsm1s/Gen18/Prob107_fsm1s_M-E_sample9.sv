module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // 2-bit shift register for state representation
    // '10' = State B, '01' = State A
    reg [1:0] state_reg;

    always @(posedge clk) begin
        if (reset) begin
            state_reg <= 2'b10;  // Reset to State B
        end
        else begin
            // Circular shift with conditional input
            state_reg <= {state_reg[0], 
                         (state_reg[1] & in) | (state_reg[0] & ~in)};
        end
    end

    // Output is MSB of state register (1 for B, 0 for A)
    assign out = state_reg[1];

endmodule