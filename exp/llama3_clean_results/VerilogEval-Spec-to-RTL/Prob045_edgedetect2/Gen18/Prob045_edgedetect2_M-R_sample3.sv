module TopModule (
    input clk,
    input reset, // Added reset signal
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;  // Register to store the previous state of the input vector

// Sequential logic to update the previous state
always @(posedge clk) begin
    if (reset) begin
        prev_in <= 8'b0;  // Reset the previous state
    end else begin
        prev_in <= in;  // Update the previous state
    end
end

// Continuous assignment for edge detection
assign anyedge = in ^ prev_in;  // Detect edges

endmodule