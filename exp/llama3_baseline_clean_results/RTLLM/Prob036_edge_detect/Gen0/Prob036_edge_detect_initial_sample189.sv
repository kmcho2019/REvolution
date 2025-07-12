module edge_detect(
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

reg prev_a;  // Register to store the previous state of signal "a"

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        prev_a <= 1'b0;  // Initialize previous state of "a" to 0
        rise <= 1'b0;  // Reset "rise" output to 0
        down <= 1'b0;  // Reset "down" output to 0
    end else begin
        if (a!= prev_a) begin  // Check for edge
            if (a == 1'b1) begin  // Rising edge detected
                rise <= 1'b1;
                down <= 1'b0;
            end else begin  // Falling edge detected
                rise <= 1'b0;
                down <= 1'b1;
            end
        end else begin  // No edge detected
            rise <= 1'b0;
            down <= 1'b0;
        end
        prev_a <= a;  // Update previous state of "a"
    end
end

endmodule