module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the shift register to hold the last 4 input bits
reg [3:0] shift_reg;

// Initialize the shift register to zero
initial shift_reg = 4'b0000;

// Shift the input bitstream on each clock cycle
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // Reset the shift register when reset_n is low
        shift_reg <= 4'b0000;
    end else begin
        // Shift the input bit into the shift register
        shift_reg <= {data_in, shift_reg[3:1]};
    end
end

// Detect the sequence and assert the output signal
always_comb begin
    // Compare the current shift register state with the target sequence
    if (shift_reg == 4'b1001) begin
        sequence_detected = 1'b1;
    end else begin
        sequence_detected = 1'b0;
    end
end

endmodule