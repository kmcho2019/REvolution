module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;
    wire [7:0] edge_detect;

    // Combinational detection of edges by XOR between current input and delayed input
    assign edge_detect = in ^ in_dly;

    // Sequential update: delay input and output edge detection one cycle later
    always @(posedge clk) begin
        in_dly <= in;
        anyedge <= edge_detect;
    end
endmodule