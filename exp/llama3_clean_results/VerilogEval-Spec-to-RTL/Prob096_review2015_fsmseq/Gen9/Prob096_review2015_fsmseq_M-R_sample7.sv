module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

reg [3:0] shift_reg; // 4-bit shift register
reg seq_found; // Flag to track if sequence '1101' has been found

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000; // Reset shift register
        seq_found <= 0; // Reset sequence found flag
    end else begin
        shift_reg <= {shift_reg[2:0], data}; // Shift register and append new bit
        if (shift_reg == 4'b1101) begin // Check if sequence matches
            seq_found <= 1; // Set sequence found flag
        end
    end
end

assign start_shifting = seq_found; // Drive start_shifting directly from seq_found flag

endmodule