module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg prev_a;  // Register to store the previous state of 'a'

// Sequential logic to store the previous state of 'a' and reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all signals to a known state
        prev_a <= 1'b0;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        prev_a <= a;
    end
end

// Combinational logic for edge detection simplified
always @(posedge clk) begin
    if (a !== prev_a) begin
        // Edge detected, set rise or down accordingly
        rise <= a;
        down <= ~a;
    end else begin
        // No edge detected, reset the signals
        rise <= 1'b0;
        down <= 1'b0;
    end
end

endmodule