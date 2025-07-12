module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_state;  // Register to store the previous state of the input vector

// Initialize the previous state register to a known value at the start
initial begin
    prev_state = 8'b0;
end

// Sequential logic to update the previous state and detect edges
always @(posedge clk) begin
    // Update the previous state
    prev_state <= in;
    
    // Detect edges by comparing the current state with the previous state
    // Using the XOR operator (^) for simplicity and efficiency
    anyedge <= in ^ prev_state;
end

endmodule