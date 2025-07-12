module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] prev_in2;  // Additional pipeline stage
    wire [7:0] edge_detect;
    wire clk_gate;
    wire gated_clk;

    // Clock gating logic - only enable when input changes
    assign clk_gate = (in != prev_in);
    assign gated_clk = clk & clk_gate;

    // Combinational edge detection
    assign edge_detect = in ^ prev_in2;

    // First pipeline stage (clock gated)
    always @(posedge gated_clk) begin
        prev_in <= in;
    end

    // Second pipeline stage (regular clock)
    always @(posedge clk) begin
        prev_in2 <= prev_in;
        anyedge <= edge_detect;
    end

endmodule