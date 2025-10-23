module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;
    wire [7:0] edge_detect;
    wire any_edge_enable;

    assign edge_detect = in ^ in_dly;
    assign any_edge_enable = |edge_detect;

    always @(posedge clk) begin
        in_dly <= in;
        if (any_edge_enable)
            anyedge <= edge_detect;
        else
            anyedge <= 8'b0;
    end
endmodule