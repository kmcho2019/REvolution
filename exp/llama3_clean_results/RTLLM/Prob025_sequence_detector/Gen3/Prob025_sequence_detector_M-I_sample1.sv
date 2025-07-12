module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// Define the target sequence
parameter TARGET_SEQUENCE = 4'b1001;

// 4-bit shift register to hold the incoming data
reg [3:0] shift_register;

// Update the shift register and assert sequence_detected if the shift register matches the target sequence
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_register <= 4'b0000;
        sequence_detected <= 1'b0;
    end else begin
        shift_register <= {data_in, shift_register[3:1]};
        sequence_detected <= (shift_register == TARGET_SEQUENCE) ? 1'b1 : 1'b0;
    end
end

endmodule