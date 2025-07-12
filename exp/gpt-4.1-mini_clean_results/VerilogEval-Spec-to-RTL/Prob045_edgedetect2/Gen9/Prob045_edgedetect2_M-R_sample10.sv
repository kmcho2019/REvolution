module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;
    reg [7:0] edge_detect;

    // Combinational block to detect edges based on current and delayed input
    always @(*) begin
        edge_detect = in ^ in_dly;
    end

    // Sequential block to update delayed input and anyedge output on rising edge of clk
    always @(posedge clk) begin
        in_dly <= in;
        anyedge <= edge_detect;
    end
endmodule