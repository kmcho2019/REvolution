module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Decision tree nodes
reg match_bit1;  // First bit match (looking for '1')
reg match_bit2;  // First two bits match (looking for '10')
reg match_bit3;  // First three bits match (looking for '100')
reg match_bit4;  // Full sequence match (looking for '1001')

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        match_bit1 <= 1'b0;
        match_bit2 <= 1'b0;
        match_bit3 <= 1'b0;
        match_bit4 <= 1'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Level 1: Check first bit
        match_bit1 <= (data_in == 1'b1);
        
        // Level 2: Check second bit if first matched
        match_bit2 <= match_bit1 && (data_in == 1'b0);
        
        // Level 3: Check third bit if first two matched
        match_bit3 <= match_bit2 && (data_in == 1'b0);
        
        // Level 4: Check fourth bit if first three matched
        match_bit4 <= match_bit3 && (data_in == 1'b1);
        
        // Output is the final level match
        sequence_detected <= match_bit4;
    end
end

endmodule