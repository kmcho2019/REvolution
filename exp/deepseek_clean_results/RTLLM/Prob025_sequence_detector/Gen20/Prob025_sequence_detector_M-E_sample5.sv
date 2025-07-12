module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

reg [3:0] window;  // 4-bit sliding window of recent inputs

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        window <= 4'b0;
        sequence_detected <= 1'b0;
    end else begin
        // Shift in new bit and maintain last 3 bits
        window <= {window[2:0], data_in};
        
        // Check for pattern match (1001)
        sequence_detected <= (window[2:0] == 3'b100) && (data_in == 1'b1);
    end
end

endmodule