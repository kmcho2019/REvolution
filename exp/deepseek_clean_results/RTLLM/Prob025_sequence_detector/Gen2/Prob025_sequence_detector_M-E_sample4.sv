module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

    // 4-bit shift register to store the sequence
    reg [3:0] shift_reg;

    // Shift register operation and detection logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            shift_reg <= 4'b0;
            sequence_detected <= 1'b0;
        end else begin
            // Shift in new bit and shift out oldest bit
            shift_reg <= {shift_reg[2:0], data_in};
            
            // Check for sequence match (1001)
            sequence_detected <= (shift_reg == 4'b1001);
        end
    end

endmodule