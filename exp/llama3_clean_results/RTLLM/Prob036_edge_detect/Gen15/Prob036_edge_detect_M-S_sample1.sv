module edge_detect (
    input  clk,          // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,           // Input signal to detect edges
    output reg rise,     // Output signal indicating a rising edge
    output reg down      // Output signal indicating a falling edge
);

reg prev_a = 1'b0;      // Register to hold the previous state of 'a', initialized to 0

// Sequential logic to detect edges
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        if (a && !prev_a) begin // Rising edge detection
            rise <= 1'b1;
            down <= 1'b0;
        end else if (!a && prev_a) begin // Falling edge detection
            rise <= 1'b0;
            down <= 1'b1;
        end else begin
            rise <= 1'b0;
            down <= 1'b0;
        end
        prev_a <= a;         // Update previous state
    end
end

endmodule