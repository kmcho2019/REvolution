module edge_detect (
    input  clk,         // Clock signal
    input  rst_n,        // Reset signal (active low)
    input  a,            // Input signal
    output rise,         // Output signal indicating a rising edge
    output down          // Output signal indicating a falling edge
);

reg prev_a;             // Flip-flop to store the previous value of 'a'

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin   // Reset
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        if (a &&!prev_a) begin  // Rising edge detected
            rise <= 1'b1;
            down <= 1'b0;
        end else if (!a && prev_a) begin  // Falling edge detected
            rise <= 1'b0;
            down <= 1'b1;
        end else begin
            rise <= 1'b0;
            down <= 1'b0;
        end
        prev_a <= a;    // Update the previous value
    end
end

endmodule