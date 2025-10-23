module edge_detect (
    input         clk,       // Clock signal
    input         rst_n,     // Reset signal (active low)
    input         a,         // Input signal
    output reg    rise,      // Output signal indicating a rising edge
    output reg    down       // Output signal indicating a falling edge
);

reg prev_a;  // Previous state of input signal 'a'

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 1'b0;  // Reset previous state of 'a' to 0
        rise   <= 1'b0;  // Reset 'rise' to 0
        down  <= 1'b0;  // Reset 'down' to 0
    end else begin
        if (a && !prev_a) begin
            rise <= 1'b1;  // Set 'rise' to 1 if a rising edge is detected
            down <= 1'b0;
        end else if (!a && prev_a) begin
            rise <= 1'b0;
            down <= 1'b1;  // Set 'down' to 1 if a falling edge is detected
        end else begin
            rise <= 1'b0;
            down <= 1'b0;  // Set both 'rise' and 'down' to 0 otherwise
        end
        prev_a <= a;  // Update previous state of 'a' to its current state
    end
end

endmodule