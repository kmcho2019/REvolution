module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// 3-bit shift register to store last 3 samples
reg [2:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear shift register and output on reset
        shift_reg <= 3'b000;
        data_out <= 1'b0;
    end
    else begin
        // Shift in new data (MSB is oldest sample)
        shift_reg <= {shift_reg[1:0], data_in};
        
        // Detect 0->1->0 pattern (010 in shift_reg)
        // Output is high for one cycle when pattern is detected
        data_out <= (shift_reg == 3'b010);
    end
end

endmodule