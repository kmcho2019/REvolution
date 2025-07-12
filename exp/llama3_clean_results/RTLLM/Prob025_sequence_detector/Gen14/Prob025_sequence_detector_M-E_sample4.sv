module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

reg [3:0] shift_register;

// Initialize the shift register on reset
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        shift_register <= 4'b0000;
        sequence_detected <= 1'b0;
    end else begin
        // Shift in the new data bit
        shift_register <= {data_in, shift_register[3:1]};
        
        // Check if the captured bits match the expected sequence
        if (shift_register == 4'b1001) begin
            sequence_detected <= 1'b1;
        end else begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule