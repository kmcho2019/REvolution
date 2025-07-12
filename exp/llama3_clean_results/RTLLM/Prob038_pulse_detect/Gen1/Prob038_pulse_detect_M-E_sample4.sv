module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // 3-bit shift register to store input history

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        shift_reg <= 3'b000; // Clear shift register
        data_out <= 0; // No pulse initially
    end else begin
        // Shift in the current input value
        shift_reg <= {data_in, shift_reg[2:1]};
        
        // Check if the pattern in the shift register indicates a pulse
        if (shift_reg == 3'b010) begin
            data_out <= 1; // Pulse detected
        end else begin
            data_out <= 0; // No pulse
        end
    end
end

endmodule