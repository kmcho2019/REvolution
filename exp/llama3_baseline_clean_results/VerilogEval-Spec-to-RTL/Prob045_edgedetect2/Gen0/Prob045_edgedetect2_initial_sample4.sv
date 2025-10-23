module TopModule(
    input           clk,
    input [7:0]      in,
    output [7:0]     anyedge
);

reg [7:0] prev_in;  // Register to store the previous input state

always @(posedge clk) begin
    anyedge <= (in ^ prev_in);  // Set anyedge bits where input has changed
    prev_in <= in;              // Update previous state register
end

endmodule