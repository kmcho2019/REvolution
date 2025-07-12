module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] edge_detect;

always @ (posedge clk) begin
    prev_in <= in;
    edge_detect <= prev_in ^ in;
end

always @ (posedge clk) begin
    if (edge_detect != 8'b0) begin
        anyedge <= edge_detect;
    end else begin
        anyedge <= 8'b0;
    end
end

endmodule