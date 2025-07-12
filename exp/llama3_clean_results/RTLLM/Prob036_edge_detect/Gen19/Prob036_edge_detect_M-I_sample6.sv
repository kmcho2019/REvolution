module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg prev_a;  // Reg to store the previous state of 'a'

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the previous state and output signals
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Store the current state of 'a' in the previous state reg
        prev_a <= a;
        
        // Detect rising and falling edges
        if (a &&!prev_a) begin
            // Rising edge detected, set 'rise' to 1
            rise <= 1'b1;
            down <= 1'b0;
        end else if (!a && prev_a) begin
            // Falling edge detected, set 'down' to 1
            rise <= 1'b0;
            down <= 1'b1;
        end else if (rise || down) begin
            // Reset 'rise' and 'down' to 0 after one clock cycle
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // No edge detected, keep 'rise' and 'down' as they are
            rise <= rise;
            down <= down;
        end
    end
end

endmodule