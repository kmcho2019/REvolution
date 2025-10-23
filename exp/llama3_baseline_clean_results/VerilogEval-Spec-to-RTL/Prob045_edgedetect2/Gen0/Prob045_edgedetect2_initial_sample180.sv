module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;
reg [7:0] edge;

always @(posedge clk) begin
    prev_in <= in;
    anyedge <= edge;
end

assign edge = in ^ prev_in;

endmodule