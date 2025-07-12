module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg sign_bit; // Flag to indicate if the sign bit has been encountered
reg carry_bit; // Carry bit for the 2's complement calculation

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        // Reset all internal states to their initial values
        sign_bit <= 1'b0;
        carry_bit <= 1'b0;
    end else begin
        // If the sign bit has not been encountered yet
        if (~sign_bit) begin
            // If the current input bit is 1, set the sign bit
            if (x) begin
                sign_bit <= 1'b1;
            end
            // Output the current input bit as is (since it's before the sign bit)
            z <= x;
        end else begin
            // Calculate the 2's complement output
            z <= carry_bit ^ ~x;
            // Update the carry bit for the next clock cycle
            carry_bit <= carry_bit & ~x | (~carry_bit & x);
        end
    end
end

endmodule