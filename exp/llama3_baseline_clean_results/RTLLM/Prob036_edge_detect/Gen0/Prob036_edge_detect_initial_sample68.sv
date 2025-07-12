module edge_detect (
    input clk,    // Clock signal
    input rst_n,  // Reset signal (active low)
    input a,      // Input signal
    output rise,  // Output signal indicating a rising edge
    output down   // Output signal indicating a falling edge
);

reg prev_a;  // Internal register to store the previous state of 'a'

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 1'b0;  // Reset the internal register on reset
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        if (a && ~prev_a) begin  // Rising edge detection
            rise <= 1'b1;
            down <= 1'b0;
        end else if (~a && prev_a) begin  // Falling edge detection
            rise <= 1'b0;
            down <= 1'b1;
        end else begin
            rise <= 1'b0;
            down <= 1'b0;
        end
        prev_a <= a;  // Update the internal register with the current state of 'a'
    end
end

endmodule