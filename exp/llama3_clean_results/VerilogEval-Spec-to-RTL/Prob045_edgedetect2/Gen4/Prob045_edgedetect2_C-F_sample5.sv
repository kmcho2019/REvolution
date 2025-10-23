module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

reg [7:0] prev_in;

initial begin
    prev_in = 8'b0; // Initialize the previous state register
end

always @(posedge clk) begin
    anyedge <= in ^ prev_in; // Detect edges using XOR operation
    prev_in <= in; // Update the previous state
end

endmodule