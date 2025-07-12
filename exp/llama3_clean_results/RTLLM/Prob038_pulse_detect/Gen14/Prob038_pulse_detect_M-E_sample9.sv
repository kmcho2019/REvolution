module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] shift_reg; // 3-bit shift register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 3'b000; // Reset shift register
        data_out <= 0; // Reset output
    end else begin
        shift_reg <= {shift_reg[1:0], data_in}; // Shift in new value of data_in
        if (shift_reg == 3'b010) begin // Check for pulse pattern
            data_out <= 1; // Assert data_out if pulse detected
        end else begin
            data_out <= 0; // Deassert data_out otherwise
        end
    end
end

endmodule