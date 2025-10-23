module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// 4-bit shift register to store recent inputs
reg [3:0] shift_reg;

// Shift register update logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg <= 4'b0;
    end else begin
        shift_reg <= {shift_reg[2:0], data_in};
    end
end

// Pattern detection (combinatorial)
assign sequence_detected = (shift_reg == 4'b1001);

endmodule