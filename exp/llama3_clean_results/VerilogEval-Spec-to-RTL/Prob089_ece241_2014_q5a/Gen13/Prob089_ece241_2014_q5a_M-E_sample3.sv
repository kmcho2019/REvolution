module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [7:0] shift_reg; // Using an 8-bit register for demonstration; actual size can vary

always @(posedge clk or posedge areset) begin
    if (areset) begin
        shift_reg <= 8'b0; // Clear the register on reset
    end else begin
        // Shift the input bit into the register
        shift_reg <= {shift_reg[6:0], x};
        
        // Generate the output by XORing the current input bit with the MSB of the register
        z <= x ^ shift_reg[7];
    end
end

endmodule