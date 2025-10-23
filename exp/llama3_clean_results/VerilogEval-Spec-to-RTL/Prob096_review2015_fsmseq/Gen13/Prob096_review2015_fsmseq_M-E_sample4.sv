module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_register; // 4-bit shift register to store last 4 bits

// Sequential logic for shift register and start_shifting
always @(posedge clk) begin
    if (reset) begin
        shift_register <= 4'b0000; // Reset shift register
        start_shifting <= 1'b0; // Reset start_shifting flag
    end else begin
        shift_register <= {shift_register[2:0], data}; // Shift in new data bit
        if (shift_register == 4'b1101) begin // Check if sequence is detected
            start_shifting <= 1'b1; // Set start_shifting flag if sequence detected
        end
    end
end

endmodule