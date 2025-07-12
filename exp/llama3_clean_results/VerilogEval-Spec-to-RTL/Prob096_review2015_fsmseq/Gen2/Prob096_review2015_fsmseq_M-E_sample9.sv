module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_register; // stores the last four bits of the input sequence
reg sequence_detected; // indicates whether the sequence '1101' has been detected

always @(posedge clk) begin
    if (reset) begin
        shift_register <= 4'b0000; // clear the shift register
        sequence_detected <= 1'b0; // reset the sequence detected flag
        start_shifting <= 1'b0; // reset the start shifting output
    end else begin
        // shift in the new input bit
        shift_register <= {data, shift_register[3:1]};
        
        // check if the sequence '1101' has been detected
        if (shift_register == 4'b1101 && !sequence_detected) begin
            sequence_detected <= 1'b1; // set the sequence detected flag
        end
        
        // set the start shifting output
        if (sequence_detected) begin
            start_shifting <= 1'b1; // set the start shifting output to '1'
        end else begin
            start_shifting <= 1'b0; // reset the start shifting output to '0'
        end
    end
end

endmodule