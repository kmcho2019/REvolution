module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// 4-bit shift register to detect the sequence
reg [3:0] shift_reg;
// Flag to indicate if the sequence '1101' has been found
reg seq_found;

always @(posedge clk) begin
    // Active high synchronous reset
    if (reset) begin
        // Reset shift register and sequence found flag
        shift_reg <= 4'b0000;
        seq_found <= 0;
    end else begin
        // Shift register update logic
        shift_reg <= {shift_reg[2:0], data};
        
        // Check if the sequence matches '1101'
        if (shift_reg == 4'b1101) begin
            // Set sequence found flag if match is found
            seq_found <= 1;
        end
    end
end

// Drive start_shifting directly from seq_found flag
assign start_shifting = seq_found;

endmodule