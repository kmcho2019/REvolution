module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

// Define the desired sequence
parameter DESIRED_SEQUENCE = 4'b1001;

// 4-bit shift register to store the input data stream
reg [3:0] shift_register;

// Comparator to check for the desired sequence
wire sequence_match;

// Control logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_register <= 4'b0000;
    end else begin
        // Shift in the new data bit
        shift_register <= {shift_register[2:0], data_in};
    end
end

// Comparator logic
assign sequence_match = (shift_register == DESIRED_SEQUENCE);

// Output logic
assign sequence_detected = sequence_match;

endmodule