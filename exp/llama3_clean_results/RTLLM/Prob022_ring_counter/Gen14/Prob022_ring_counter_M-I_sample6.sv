module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] shift_reg; // 8-bit shift register

always @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 8'b0000_0001; // Initialize to starting state when reset is high
    end else begin
        // Shift right and reintroduce the '1' at LSB
        shift_reg <= {1'b1, shift_reg[7:1]};
    end
end

assign out = shift_reg; // Continuous assignment to output the current state

endmodule