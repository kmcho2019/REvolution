module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

reg [7:0] shift_reg = 8'h34; // Initialize shift register to 0x34

always @(negedge clk) begin
    if (reset) begin
        shift_reg <= 8'h34; // Reset shift register to 0x34 on reset
    end else begin
        shift_reg <= {shift_reg[6:0], d[7]}; // Shift in the new bit from d
    end
end

assign q = shift_reg; // Assign the output to the shift register

endmodule