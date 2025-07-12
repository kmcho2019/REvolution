module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] edge_detected;

// Initialize the previous input register to avoid undefined behavior
initial begin
    prev_in = 8'b0;
end

// Sequential logic to update the previous input register and detect edges
always @(posedge clk) begin
    edge_detected <= (in ^ prev_in);
    prev_in <= in;
end

// Continuous assignment to the output
assign anyedge = edge_detected;

endmodule