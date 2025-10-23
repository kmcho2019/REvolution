module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_register; // 4-bit shift register to store recent history

// Initialize the shift register
initial shift_register = 4'b0000;

// Synchronous update of the shift register
always @(posedge clk) begin
    if(reset) begin
        shift_register <= 4'b0000;
        start_shifting <= 0;
    end else begin
        shift_register <= {shift_register[2:0], data}; // Shift in new data
        if(shift_register == 4'b1101) begin
            start_shifting <= 1; // Set start_shifting if sequence is found
        end else if(reset) begin
            start_shifting <= 0; // Reset start_shifting on reset
        end
    end
end

endmodule