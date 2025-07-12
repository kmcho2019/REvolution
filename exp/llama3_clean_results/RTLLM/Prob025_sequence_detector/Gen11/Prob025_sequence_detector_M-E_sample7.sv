module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// 4-bit shift register to store the last four incoming bits
reg [3:0] shift_reg;

// Comparator to check if the shift register contents match the desired sequence
wire match;

// Desired sequence
reg [3:0] desired_sequence = 4'b1001;

// Initialize the shift register and output on reset
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        shift_reg <= 4'b0000;
        sequence_detected <= 1'b0;
    end else begin
        // Shift in the new bit and shift out the oldest bit
        shift_reg <= {shift_reg[2:0], data_in};
        
        // Check if the shift register contents match the desired sequence
        if (shift_reg == desired_sequence) begin
            sequence_detected <= 1'b1;
        end else begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule