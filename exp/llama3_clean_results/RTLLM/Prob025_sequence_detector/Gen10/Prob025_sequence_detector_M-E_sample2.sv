module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the desired sequence
parameter DESIRED_SEQUENCE = 4'b1001;

// 4-bit shift register
reg [3:0] shift_register;

// Reset the shift register
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        shift_register <= 4'b0000;
    end else begin
        shift_register <= {shift_register[2:0], data_in};
    end
end

// Compare the shift register with the desired sequence
always @(posedge clk) begin
    if (shift_register == DESIRED_SEQUENCE) begin
        sequence_detected <= 1'b1;
    end else begin
        sequence_detected <= 1'b0;
    end
end

endmodule