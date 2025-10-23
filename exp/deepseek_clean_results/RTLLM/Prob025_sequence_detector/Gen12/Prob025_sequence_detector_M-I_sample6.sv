module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    input data_valid,    // New enable signal for power optimization
    output sequence_detected
);

reg [3:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shift_reg <= 4'b0;
    else if (data_valid)  // Only update when new data is valid
        shift_reg <= {shift_reg[2:0], data_in};
end

// Efficient pattern matching using direct bit checks
assign sequence_detected = shift_reg[3] & ~shift_reg[2] & ~shift_reg[1] & shift_reg[0];

endmodule