module edge_detect(
    input clk, // Clock signal
    input rst_n, // Reset signal (active low)
    input a, // Input signal
    output reg rise, // Output signal indicating a rising edge
    output reg down // Output signal indicating a falling edge
);

reg prev_a; // Flip-flop to store the previous state of 'a'

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        rise <= 0;
        down <= 0;
        prev_a <= 0;
    end else begin
        // Store the previous state of 'a'
        prev_a <= a;

        // Check for rising edge
        if (a == 1 && prev_a == 0) begin
            rise <= 1;
            down <= 0;
        end
        // Check for falling edge
        else if (a == 0 && prev_a == 1) begin
            down <= 1;
            rise <= 0;
        end
        // No edge detected, reset outputs
        else begin
            rise <= 0;
            down <= 0;
        end
    end
end

endmodule