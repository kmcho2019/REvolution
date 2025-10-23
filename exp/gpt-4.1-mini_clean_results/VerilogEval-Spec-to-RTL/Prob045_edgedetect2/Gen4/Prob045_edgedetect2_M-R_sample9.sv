module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] in_dly;
    reg [7:0] edge_dly;

    always @(posedge clk) begin
        in_dly <= in;
        edge_dly <= in ^ in_dly;
        anyedge <= edge_dly;
    end

endmodule