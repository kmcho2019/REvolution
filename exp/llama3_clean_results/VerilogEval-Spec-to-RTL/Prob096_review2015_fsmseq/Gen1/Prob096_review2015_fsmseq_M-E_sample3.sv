module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_register; // 4-bit shift register to track the last 4 bits of the input data

always @(posedge clk) begin
    if (reset) begin
        shift_register <= 4'b0000; // Reset the shift register
        start_shifting <= 0;
    end else begin
        shift_register <= {shift_register[2:0], data}; // Shift in the new data bit
        if (shift_register == 4'b1101) begin // Check if the shift register matches the target sequence
            start_shifting <= 1;
        end else if (start_shifting) begin // If start_shifting is already 1, maintain it
            start_shifting <= 1;
        end else begin
            start_shifting <= 0;
        end
    end
end

endmodule