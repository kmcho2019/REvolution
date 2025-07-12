module TopModule(
    input  clk,
    input  reset,
    input  data,
    output reg start_shifting
);

reg [3:0] shift_reg; // 4-bit shift register
reg seq_detected; // Flag to indicate sequence detection

// Target sequence
localparam TARGET_SEQ = 4'b1101;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0000; // Reset shift register
        start_shifting <= 0; // Reset start_shifting
        seq_detected <= 0; // Reset sequence detected flag
    end else begin
        // Shift in new data
        shift_reg <= {shift_reg[2:0], data};
        
        // Check if target sequence is detected
        if (shift_reg == TARGET_SEQ && !seq_detected) begin
            start_shifting <= 1; // Set start_shifting if sequence detected
            seq_detected <= 1; // Set sequence detected flag
        end
    end
end

endmodule