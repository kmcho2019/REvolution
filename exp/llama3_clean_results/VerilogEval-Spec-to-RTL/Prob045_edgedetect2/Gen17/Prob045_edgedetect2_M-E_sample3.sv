module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_state;  // Register to store the previous state of the input vector
reg [7:0] curr_state;  // Register to store the current state of the input vector

// Initialize the current and previous state registers to a known value at the start
initial begin
    prev_state = 8'b0;
    curr_state = 8'b0;
    anyedge = 8'b0;
end

// Sequential logic to update the current and previous states
always @(posedge clk) begin
    prev_state <= curr_state;  // Update the previous state
    curr_state <= in;  // Update the current state
end

// Combinational logic to detect edges
always @(*) begin
    anyedge = (curr_state & ~prev_state) | (~curr_state & prev_state);  // Detect rising and falling edges
end

endmodule