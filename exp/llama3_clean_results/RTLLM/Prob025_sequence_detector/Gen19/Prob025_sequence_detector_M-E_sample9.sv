module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

// Define the expected sequence
parameter EXPECTED_SEQUENCE = 4'b1001;

// Shift register to store the last 4 bits of the input sequence
reg [3:0] shift_register;

// Update the shift register on each clock cycle
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_register <= 4'b0000;
    end else begin
        shift_register <= {shift_register[2:0], data_in};
    end
end

// Comparator to check for a match with the expected sequence
assign sequence_detected = (shift_register == EXPECTED_SEQUENCE);

endmodule