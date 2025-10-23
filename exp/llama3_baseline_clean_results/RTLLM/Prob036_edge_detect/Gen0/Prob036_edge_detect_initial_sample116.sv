module edge_detect(
    input        clk,       // Clock signal
    input        rst_n,     // Reset signal (active low)
    input        a,         // Input signal
    output       rise,      // Output signal indicating a rising edge
    output       down       // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of signal a

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 1'b0;  // Reset the previous state of signal a
        rise <= 1'b0;    // Reset the rise output signal
        down <= 1'b0;    // Reset the down output signal
    end else begin
        prev_a <= a;     // Store the current state of signal a
        if (a &&!prev_a) begin
            rise <= 1'b1;  // Set the rise output signal to 1 for one clock cycle
            down <= 1'b0;  // Reset the down output signal
        end else if (!a && prev_a) begin
            down <= 1'b1;  // Set the down output signal to 1 for one clock cycle
            rise <= 1'b0;  // Reset the rise output signal
        end else begin
            rise <= 1'b0;  // Reset the rise output signal
            down <= 1'b0;  // Reset the down output signal
        end
    end
end

endmodule