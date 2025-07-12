module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the shift register
reg [3:0] shift_reg;

// Initialize the shift register
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg <= 4'b0000; // Reset the shift register
    end else begin
        shift_reg <= {shift_reg[:0], data_in}; // Shift in the new data bit
    end
end

// Compare the shift register contents with the desired sequence
assign sequence_detected = (shift_reg == 4'b1001);

endmodule