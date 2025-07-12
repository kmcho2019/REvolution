module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

// Shift register to store the last four bits of the input data stream
reg [3:0] shift_register;

// Comparator to check for the desired sequence
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        shift_register <= 4'b0000;
    end else begin
        shift_register <= {shift_register[2:0], data_in};
    end
end

// Output logic to detect the sequence
assign sequence_detected = (shift_register == 4'b1001);

endmodule