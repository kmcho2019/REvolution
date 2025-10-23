module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_reg; // 4-bit shift register to store recent input history

// Initialize the shift register
initial shift_reg = 4'b0000;

// Shift register update logic
always @(posedge clk) begin
    if(reset) begin
        shift_reg <= 4'b0000; // Reset shift register on reset
        start_shifting <= 0; // Clear start_shifting on reset
    end else begin
        shift_reg <= {shift_reg[2:0], data}; // Shift in new data
        if(shift_reg == 4'b1101) begin
            start_shifting <= 1; // Set start_shifting when sequence is detected
        end else if(reset) begin
            start_shifting <= 0; // Clear start_shifting on reset
        end
    end
end

endmodule