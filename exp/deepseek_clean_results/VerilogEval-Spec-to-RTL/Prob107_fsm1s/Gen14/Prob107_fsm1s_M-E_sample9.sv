module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // 2-bit shift register for state representation
    reg [1:0] state_reg;

    // State transition and reset logic
    always @(posedge clk) begin
        if (reset) begin
            state_reg <= 2'b01;  // Reset to state B ('01')
        end else begin
            // Shift operation with next state determination
            state_reg <= {state_reg[0], 
                         (state_reg[0] ? in : ~in)};
        end
    end

    // Output logic - directly from LSB (inverted for correct output)
    assign out = state_reg[0];

endmodule