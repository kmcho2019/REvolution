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

// Initialize the shift register
initial begin
    shift_register = 4'b0000;
end

// Shift register logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        shift_register <= 4'b0000;
    end else begin
        shift_register <= {shift_register[2:0], data_in};
    end
end

// Comparator
assign sequence_detected = (shift_register == DESIRED_SEQUENCE) ? 1'b1 : 1'b0;

endmodule