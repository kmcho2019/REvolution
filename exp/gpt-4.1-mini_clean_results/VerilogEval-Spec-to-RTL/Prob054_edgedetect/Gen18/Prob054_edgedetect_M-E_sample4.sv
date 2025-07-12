module TopModule (
    input          clk,
    input   [7:0]  in,
    output  reg [7:0] pedge
);

    reg [7:0] in_d1, in_d2;
    wire [7:0] edge_detect;

    // Pipeline input through two stages
    always @(posedge clk) begin
        in_d1 <= in;
        in_d2 <= in_d1;
    end

    // Combinational logic to detect positive edges one cycle after transition
    assign edge_detect = in_d1 & ~in_d2;

    // Register output pedge to assert one cycle after detecting the edge
    always @(posedge clk) begin
        pedge <= edge_detect;
    end

endmodule