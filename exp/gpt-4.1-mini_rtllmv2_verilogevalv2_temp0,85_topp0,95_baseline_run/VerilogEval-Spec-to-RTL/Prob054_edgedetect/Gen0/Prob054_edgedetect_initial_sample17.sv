module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);
    reg [7:0] in_d;           // delayed version of input
    reg [7:0] detected_edge; // detected positive edges on current clock

    always @(posedge clk) begin
        in_d <= in;
        detected_edge <= (~in_d) & in;  // 0 -> 1 transition detection
        pedge <= detected_edge;         // output delayed by one cycle
    end
endmodule