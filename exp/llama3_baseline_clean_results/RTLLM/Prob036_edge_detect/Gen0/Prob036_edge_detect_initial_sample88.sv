module edge_detect(
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg prev_a;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all signals to their initial states
        rise <= 0;
        down <= 0;
        prev_a <= 0;
    end else begin
        // Store the current state of 'a' in 'prev_a' for the next clock cycle
        prev_a <= a;

        // Check for rising and falling edges
        if (a &&!prev_a) begin
            // Rising edge detected
            rise <= 1;
            down <= 0;
        end else if (!a && prev_a) begin
            // Falling edge detected
            rise <= 0;
            down <= 1;
        end else begin
            // No edge detected, reset 'rise' and 'down'
            rise <= 0;
            down <= 0;
        end
    end
end

endmodule