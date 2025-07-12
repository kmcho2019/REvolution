module sequence_detector (
    input wire clk,
    input wire reset_n,    // Active low reset
    input wire data_in,
    output reg sequence_detected
);

// Parameter for the target sequence (MSB first)
parameter TARGET_PATTERN = 4'b1001;

reg [3:0] shift_reg;
reg pattern_match;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        shift_reg <= 4'b0;
        pattern_match <= 1'b0;
        sequence_detected <= 1'b0;
    end else begin
        // Shift in new data
        shift_reg <= {shift_reg[2:0], data_in};
        
        // Compare with target pattern
        pattern_match <= (shift_reg == TARGET_PATTERN);
        
        // Registered output to prevent glitches
        sequence_detected <= pattern_match;
    end
end

endmodule