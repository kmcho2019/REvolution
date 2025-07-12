module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [3:0] shift_reg; // 4-bit shift register to store last four bits

always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        shift_reg <= 4'b0000; // Reset shift register
        sequence_detected <= 1'b0; // Reset output
    end else begin
        shift_reg <= {shift_reg[2:0], data_in}; // Shift in new bit
        sequence_detected <= (shift_reg == 4'b1001) ? 1'b1 : 1'b0; // Check for sequence match
    end
end

endmodule