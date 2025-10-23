module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Edge-triggered input sampling
reg [3:0] history;
wire new_bit = data_in;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        history <= 4'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Shift in new bit while maintaining history
        history <= {history[2:0], new_bit};
        
        // Binary decision tree for pattern matching
        sequence_detected <= 
            (history[2] & ~history[1] & ~history[0] & new_bit) |  // Pattern 1001 starting at bit 2
            (~history[2] & history[1] & ~history[0] & new_bit) |   // Pattern 001 starting at bit 1
            (history[2] & ~history[1] & ~new_bit & history[0]) |   // Pattern 100 starting at bit 2
            (~history[1] & ~history[0] & new_bit & history[3]);     // Pattern 001 starting at bit 0
    end
end

endmodule