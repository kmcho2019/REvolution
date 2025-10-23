module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;
    wire [7:0] edge_detect;
    reg [7:0] edge_detect_dly;

    // Combinational detection of edges by XOR between current input and delayed input
    assign edge_detect = in ^ in_dly;

    // Sequential logic: delay input and register edge detection
    always @(posedge clk) begin
        in_dly <= in;
        edge_detect_dly <= edge_detect;
        anyedge <= edge_detect_dly;
    end
endmodule