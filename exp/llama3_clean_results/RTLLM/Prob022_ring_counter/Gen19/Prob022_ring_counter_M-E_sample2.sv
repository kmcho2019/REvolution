module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] shift_reg; // 8-bit shift register

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize shift register to starting state
        shift_reg <= 8'b0000_0001;
    end else begin
        // Shift the contents of the register one bit to the right
        shift_reg <= {shift_reg[6:0], shift_reg[7]};
    end
end

assign out = shift_reg; // Assign the shift register to the output

endmodule