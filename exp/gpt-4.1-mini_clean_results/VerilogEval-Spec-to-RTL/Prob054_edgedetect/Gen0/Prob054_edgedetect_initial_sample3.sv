module TopModule (
    input        clk,
    input  [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;
reg [7:0] edge_detected;

always @(posedge clk) begin
    prev_in <= in;
    edge_detected <= (~prev_in & in);  // Detect 0->1 transition on bits
end

// Output the edge_detected one cycle after detection
reg [7:0] pedge_reg;

always @(posedge clk) begin
    pedge_reg <= edge_detected;
end

assign pedge = pedge_reg;

endmodule