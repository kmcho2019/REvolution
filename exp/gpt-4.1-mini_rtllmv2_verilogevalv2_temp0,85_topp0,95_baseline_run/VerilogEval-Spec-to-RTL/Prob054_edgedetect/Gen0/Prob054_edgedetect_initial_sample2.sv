module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [7:0] in_d;       // delayed version of input
    reg [7:0] pedge_d;    // registered positive edge detection result

    always @(posedge clk) begin
        in_d <= in;
        // detect 0 -> 1 transitions
        pedge_d <= (~in_d) & in;
        // output the detection result from previous cycle
        pedge <= pedge_d;
    end

endmodule