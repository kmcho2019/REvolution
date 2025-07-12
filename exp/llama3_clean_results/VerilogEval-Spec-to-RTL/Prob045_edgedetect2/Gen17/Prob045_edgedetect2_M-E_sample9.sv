module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_state;  // Register to store the previous state of the input vector

// Initialize the previous state register to a known value at the start
initial begin
    prev_state = 8'b0;
end

// Sequential logic to update the previous state
always @(posedge clk) begin
    prev_state <= in;  // Update the previous state
end

// Continuous assignment for edge detection
assign anyedge = in ^ prev_state;  // Detect edges

endmodule