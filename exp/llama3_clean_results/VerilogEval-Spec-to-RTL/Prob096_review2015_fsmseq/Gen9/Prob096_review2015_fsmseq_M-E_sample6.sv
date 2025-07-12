module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_reg; // 4-bit shift register
reg sequence_detected; // Flag to indicate sequence detection

always @(posedge clk) begin
    if(reset) begin
        shift_reg <= 4'b0000; // Reset shift register
        sequence_detected <= 1'b0; // Reset detection flag
        start_shifting <= 1'b0;
    end else begin
        // Shift in new data bit
        shift_reg <= {shift_reg[2:0], data};
        
        // Check if the sequence 1101 is detected
        if(shift_reg == 4'b1101) begin
            sequence_detected <= 1'b1; // Set detection flag
        end
        
        // Set start_shifting high if sequence is detected
        if(sequence_detected) begin
            start_shifting <= 1'b1;
        end else begin
            start_shifting <= 1'b0;
        end
    end
end

endmodule