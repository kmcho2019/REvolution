module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [3:0] pattern_window;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        pattern_window <= 4'b0;
        sequence_detected <= 1'b0;
    end else begin
        // Update the sliding window
        pattern_window <= {pattern_window[2:0], data_in};
        
        // Parallel pattern matching (1001)
        sequence_detected <= (pattern_window[3] & ~pattern_window[2] 
                            & ~pattern_window[1] & pattern_window[0]);
    end
end

endmodule