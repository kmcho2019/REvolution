module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // 2-bit shift register for state encoding
    // [1] = current state (1=B, 0=A)
    // [0] = next state
    reg [1:0] state_reg;

    // Output is the current state (MSB of register)
    assign out = state_reg[1];

    always @(posedge clk) begin
        if (reset) begin
            // Initialize to state B (output 1)
            state_reg <= 2'b11;
        end else begin
            // Shift left and calculate new LSB
            state_reg <= {state_reg[0], 
                         state_reg[1] ? in : ~in};
        end
    end

endmodule