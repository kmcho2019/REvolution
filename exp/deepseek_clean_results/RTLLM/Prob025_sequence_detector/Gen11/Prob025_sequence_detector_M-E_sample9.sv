module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// History buffer tracks last 3 bits + current input
reg [2:0] bit_history;

// Parallel pattern detection signals
wire possible_start = (bit_history[1:0] == 2'b10);
wire full_match = (bit_history == 3'b100) && data_in;
wire partial_match1 = (bit_history[0] == 1'b1) && (bit_history[2:1] == 2'b00);
wire partial_match2 = (bit_history == 3'b001);

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        bit_history <= 3'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Update history buffer (shift left and append new bit)
        bit_history <= {bit_history[1:0], data_in};
        
        // Detection logic - parallel evaluation of all possible patterns
        sequence_detected <= full_match || 
                            (possible_start && data_in && bit_history[2]) || 
                            (partial_match1 && data_in) || 
                            (partial_match2 && data_in);
    end
end

endmodule