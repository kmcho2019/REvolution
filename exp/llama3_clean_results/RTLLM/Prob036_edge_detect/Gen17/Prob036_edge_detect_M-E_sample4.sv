module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output reg    rise,     // Output signal indicating a rising edge
    output reg    down      // Output signal indicating a falling edge
);

reg [1:0] edge_flag;  // Register to store previous state of 'a' and edge detection flag

// Sequential logic to store the previous state of 'a' and reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all signals to a known state
        edge_flag <= 2'b00;
        rise <= 1'b0;
        down <= 1'b0;
    end else begin
        // Update edge_flag based on current state of 'a'
        if (a !== edge_flag[0]) begin
            edge_flag[0] <= a;  // Update previous state
            edge_flag[1] <= 1'b1;  // Set edge detection flag
        end else begin
            edge_flag[1] <= 1'b0;  // Clear edge detection flag
        end
    end
end

// Combinational logic for output generation
always @(*) begin
    if (edge_flag[1]) begin
        // Edge detected, set rise or down accordingly
        rise = (a) ? 1'b1 : 1'b0;
        down = (a) ? 1'b0 : 1'b1;
    end else begin
        // No edge detected, reset the signals
        rise = 1'b0;
        down = 1'b0;
    end
end

endmodule