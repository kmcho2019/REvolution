module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] curr_in;  // Register to store the current state of the input vector

// Initialize the current state register to a known value at the start
initial begin
    curr_in = 8'b0;
end

// Sequential logic to update the current state
always @(posedge clk) begin
    curr_in <= in;  // Update the current state
end

// Continuous assignment for edge detection
assign anyedge = in ^ curr_in;  // Detect edges

endmodule