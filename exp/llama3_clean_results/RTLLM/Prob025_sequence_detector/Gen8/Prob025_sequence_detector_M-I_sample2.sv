module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output logic    sequence_detected
);

// Define the shift register to hold the last 4 input bits
logic [3:0] shift_reg;

// Initialize the shift register to zero
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the shift register when rst_n is low
        shift_reg <= 4'b0000;
        sequence_detected <= 1'b0;
    end else begin
        // Shift the input bit into the shift register
        shift_reg <= {data_in, shift_reg[3:1]};
        // Detect the sequence and assert the output signal
        sequence_detected <= (shift_reg == 4'b1001) ? 1'b1 : 1'b0;
    end
end

endmodule