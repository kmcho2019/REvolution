module edge_detect(
    input         clk,      // Clock signal
    input         rst_n,    // Reset signal (active low)
    input         a,        // Input signal
    output        rise,     // Output signal indicating a rising edge
    output        down      // Output signal indicating a falling edge
);

reg [1:0] state;  // State register to store the current and previous states of 'a'

// Sequential logic to update the state
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;  // Reset state to 00 (both bits are 0)
    end else begin
        state <= {a, state[0]};  // Update state by shifting in the current value of 'a'
    end
end

// Combinational logic to detect edges based on the state
assign rise = (state[1] == 1'b0) && (state[0] == 1'b1);  // Rising edge detected
assign down = (state[1] == 1'b1) && (state[0] == 1'b0);  // Falling edge detected

endmodule