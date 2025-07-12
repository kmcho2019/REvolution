module TopModule (
    input clk,
    input enable,    // Clock gating control
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] prev_in;
    reg [7:0] edge_detect;
    wire gated_clk;

    // Clock gating cell
    assign gated_clk = clk & enable;

    always @(posedge gated_clk) begin
        // First stage: store previous input and compute edge
        prev_in <= in;
        edge_detect <= in ^ prev_in;
        
        // Second stage: register the edge detection result
        anyedge <= edge_detect;
    end

endmodule