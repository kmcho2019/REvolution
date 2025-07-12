module TopModule (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] in_dly;
    wire [7:0] edge_detect;
    wire any_edge_occurs;

    assign edge_detect = in ^ in_dly;
    assign any_edge_occurs = |edge_detect;

    // Use clock gating via an enable to update anyedge only when edges occur
    always @(posedge clk) begin
        in_dly <= in;
        if (any_edge_occurs)
            anyedge <= edge_detect;
        else
            anyedge <= 8'b0;  // Optional: clear anyedge when no edge occurs
    end
endmodule