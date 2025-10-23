module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;
    reg [7:0] edge_detected;

    always @(posedge clk) begin
        in_dly <= in;
        edge_detected <= in ^ in_dly;   // XOR to detect any bit change
        anyedge <= edge_detected;       // output registered one cycle after edge
    end
endmodule