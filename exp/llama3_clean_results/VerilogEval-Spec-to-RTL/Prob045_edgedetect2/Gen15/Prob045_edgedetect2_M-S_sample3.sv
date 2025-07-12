module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;  // Register to store the previous state of the input vector

// Sequential logic to update the previous state and detect edges
always @(posedge clk) begin
    anyedge <= in ^ prev_in;  // Detect edges
    prev_in <= in;  // Update the previous state
end

endmodule