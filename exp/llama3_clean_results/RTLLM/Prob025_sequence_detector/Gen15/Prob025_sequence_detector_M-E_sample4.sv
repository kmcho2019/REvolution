module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output reg      sequence_detected
);

// Define the sequence length
parameter SEQUENCE_LENGTH = 4;

// Define the expected sequence
parameter [SEQUENCE_LENGTH-1:0] EXPECTED_SEQUENCE = 4'b1001;

// Shift register to hold the sequence
reg [SEQUENCE_LENGTH-1:0] shift_reg;

// Initialize shift register and output on reset
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        shift_reg <= '0;
        sequence_detected <= 1'b0;
    end else begin
        // Shift in new data
        shift_reg <= {shift_reg[SEQUENCE_LENGTH-2:0], data_in};
        
        // Check for sequence match
        if (shift_reg == EXPECTED_SEQUENCE) begin
            sequence_detected <= 1'b1;
        end else begin
            sequence_detected <= 1'b0;
        end
    end
end

endmodule