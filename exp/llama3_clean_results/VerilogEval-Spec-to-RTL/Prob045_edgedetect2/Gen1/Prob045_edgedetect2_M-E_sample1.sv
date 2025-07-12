module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] curr_in;
reg [7:0] prev_in;
reg [7:0] edge_detected;

always @(posedge clk) begin
    curr_in <= in;
    prev_in <= curr_in;
    edge_detected <= (curr_in ^ prev_in);
end

assign anyedge = edge_detected;

endmodule