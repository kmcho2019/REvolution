module edge_detect (
    input        clk,          // Clock signal
    input        rst_n,        // Reset signal (active low)
    input        a,            // Input signal
    output       rise,         // Output signal indicating a rising edge
    output       down          // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of signal 'a'

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the previous state and output signals
        prev_a <= 1'b0;
        rise   <= 1'b0;
        down   <= 1'b0;
    end else begin
        // Store the current state of 'a' in 'prev_a' for the next clock cycle
        prev_a <= a;

        // Check for rising and falling edges
        if (a &&!prev_a) begin
            // Rising edge detected, set 'rise' to 1
            rise <= 1'b1;
            down <= 1'b0;
        end else if (!a && prev_a) begin
            // Falling edge detected, set 'down' to 1
            rise <= 1'b0;
            down <= 1'b1;
        end else begin
            // No edge detected, reset both output signals
            rise <= 1'b0;
            down <= 1'b0;
        end
    end
end

endmodule