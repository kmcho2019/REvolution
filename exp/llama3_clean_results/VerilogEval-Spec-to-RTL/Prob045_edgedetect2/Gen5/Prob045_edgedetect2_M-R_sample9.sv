module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_state;  // Register to store the previous state of the input vector

// Initialize the previous state register
initial begin
    prev_state = 8'b0;
end

// Sequential logic to update the previous state
always @(posedge clk) begin
    prev_state <= in;  // Update the previous state
end

// Combinational logic to detect edges
assign anyedge = in ^ prev_state;

endmodule