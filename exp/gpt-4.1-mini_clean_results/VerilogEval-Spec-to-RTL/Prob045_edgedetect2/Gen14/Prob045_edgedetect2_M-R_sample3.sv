module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;
    wire [7:0] edge_detect;

    // Register previous input
    always @(posedge clk) begin
        in_dly <= in;
    end

    // Combinational XOR to detect edges between current and previous input
    assign edge_detect = in ^ in_dly;

    // Register output anyedge with delayed XOR result
    always @(posedge clk) begin
        anyedge <= edge_detect;
    end
endmodule