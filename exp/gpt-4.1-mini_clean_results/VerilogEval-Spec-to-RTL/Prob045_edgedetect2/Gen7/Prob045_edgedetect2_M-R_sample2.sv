module TopModule (
    input        clk,
    input  [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] in_dly;
    reg [7:0] edge_reg;

    // Register the delayed input for edge detection
    always @(posedge clk) begin
        in_dly <= in;
    end

    // Edge detection logic: XOR current and previous input
    wire [7:0] edge_detect = in ^ in_dly;

    // Register the detected edge, output one cycle later
    always @(posedge clk) begin
        edge_reg <= edge_detect;
        anyedge  <= edge_reg;
    end

endmodule