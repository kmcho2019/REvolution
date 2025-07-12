module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] curr_in;  // Register to store the current state of the input vector
reg [7:0] prev_in;  // Register to store the previous state of the input vector
reg [7:0] anyedge_reg;  // Register to store the edge detection result

// Initialize the current and previous state registers to a known value at the start
initial begin
    curr_in = 8'b0;
    prev_in = 8'b0;
    anyedge_reg = 8'b0;
end

// Sequential logic to update the current and previous states and detect edges
always @(posedge clk) begin
    prev_in <= curr_in;  // Update the previous state
    curr_in <= in;  // Update the current state
    anyedge_reg <= curr_in ^ prev_in;  // Detect edges and update the result
end

// Continuous assignment to output the edge detection result
assign anyedge = anyedge_reg;

endmodule