module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
wire [7:0] edge_detect;

always @(posedge clk) begin
    prev_in <= in;
end

assign edge_detect = in ^ prev_in;
assign anyedge = edge_detect;

endmodule