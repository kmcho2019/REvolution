module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg d1, d3;  // Stores bits at positions 1 and 3 cycles ago

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        d1 <= 1'b0;
        d3 <= 1'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Store current input for future comparisons
        d3 <= d1;          // 3-cycle delay
        d1 <= data_in;     // 1-cycle delay
        
        // Detect pattern: current=1, d1=0, d3=1, previous=0 (implied)
        sequence_detected <= data_in & ~d1 & d3 & (d1 ^ d3);
    end
end

endmodule