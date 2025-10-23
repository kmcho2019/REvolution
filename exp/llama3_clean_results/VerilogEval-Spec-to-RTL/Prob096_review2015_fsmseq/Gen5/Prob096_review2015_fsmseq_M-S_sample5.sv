module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_register; // stores the last four bits of the input sequence
reg detected; // flag to indicate if the sequence '1101' has been detected

// Update the shift register and start_shifting output
always @(posedge clk) begin
    if (reset) begin
        shift_register <= 4'b0000; // clear the shift register
        start_shifting <= 1'b0; // reset the start_shifting output
        detected <= 1'b0; // reset the detected flag
    end else begin
        // shift in the new input bit
        shift_register <= {data, shift_register[3:1]};
        
        // check if the sequence '1101' has been detected
        if (shift_register == 4'b1101 && !detected) begin
            detected <= 1'b1; // set the detected flag
        end
    end
end

// assign the start_shifting output based on the detected flag
always @(posedge clk) begin
    if (reset) begin
        start_shifting <= 1'b0; // reset the start_shifting output
    end else if (detected) begin
        start_shifting <= 1'b1; // set the start_shifting output
    end
end

endmodule