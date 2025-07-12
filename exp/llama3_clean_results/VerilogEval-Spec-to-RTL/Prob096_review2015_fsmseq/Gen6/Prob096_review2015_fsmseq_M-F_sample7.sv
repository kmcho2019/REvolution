module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_register; // stores the last four bits of the input sequence

// Update the shift register and start_shifting output
always @(posedge clk) begin
    if (reset) begin
        shift_register <= 4'b0000; // clear the shift register
        start_shifting <= 1'b0; // reset the start_shifting output
    end else begin
        // shift in the new input bit
        shift_register <= {data, shift_register[3:1]};
        
        // check if the sequence '1101' has been detected
        if (shift_register == 4'b1101) begin
            start_shifting <= 1'b1; // set the start_shifting output
        end
    end
end

endmodule