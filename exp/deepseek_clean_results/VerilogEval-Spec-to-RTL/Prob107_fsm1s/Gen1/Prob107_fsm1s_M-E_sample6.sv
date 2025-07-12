module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg [1:0] shift_reg;  // MSB represents current state

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 2'b10;  // Initialize to state B
        end else begin
            if (in) begin
                // Maintain current state (circular shift left with same MSB)
                shift_reg <= {shift_reg[0], shift_reg[1]};
            end else begin
                // Transition to next state (circular shift left)
                shift_reg <= {shift_reg[0], ~shift_reg[1]};
            end
        end
    end

    // Output is MSB of shift register (1 for B, 0 for A)
    assign out = shift_reg[1];

endmodule