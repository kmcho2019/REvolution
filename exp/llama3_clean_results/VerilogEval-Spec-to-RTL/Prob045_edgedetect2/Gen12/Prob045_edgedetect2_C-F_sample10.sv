module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;  // Register to store the previous state of the input vector

always @(posedge clk) begin
    prev_in <= in;  // Update the previous state
    anyedge <= in ^ prev_in;  // Detect edges
end

endmodule