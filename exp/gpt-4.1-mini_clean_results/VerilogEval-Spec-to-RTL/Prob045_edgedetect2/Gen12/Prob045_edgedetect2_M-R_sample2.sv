module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;
    reg [7:0] edge_detect;

    always @(posedge clk) begin
        in_dly <= in;
    end

    always @(posedge clk) begin
        edge_detect <= in ^ in_dly;
        anyedge <= edge_detect;
    end
endmodule