module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;
    wire [7:0] edge_detect;

    assign edge_detect = in ^ in_dly;

    always @(posedge clk) begin
        in_dly <= in;
        // Update anyedge only if there is an edge; else retain previous value to reduce toggling
        anyedge <= edge_detect ? edge_detect : anyedge;
    end
endmodule