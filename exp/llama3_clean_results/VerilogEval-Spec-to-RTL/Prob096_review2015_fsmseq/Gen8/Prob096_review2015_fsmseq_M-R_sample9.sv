module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_register; // stores the last four bits of the input sequence

// Update the shift register
always @(posedge clk) begin
    if (reset) begin
        shift_register <= 4'b0000; // clear the shift register
    end else begin
        // shift in the new input bit
        shift_register <= {data, shift_register[3:1]};
    end
end

// Set start_shifting based on the shift register and reset
always @(posedge clk) begin
    if (reset) begin
        start_shifting <= 1'b0; // reset the start_shifting output
    end else if (shift_register == 4'b1101 && ~start_shifting) begin
        start_shifting <= 1'b1; // set start_shifting to 1 when sequence '1101' is detected
    end else if (~reset && start_shifting) begin
        start_shifting <= start_shifting; // keep start_shifting set
    end
end

endmodule