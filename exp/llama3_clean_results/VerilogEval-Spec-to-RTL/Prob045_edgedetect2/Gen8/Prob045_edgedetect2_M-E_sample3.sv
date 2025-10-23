module EdgeDetector(
    input  current,
    input  previous,
    output edge
);
    always @(*) begin
        edge = (current!= previous)? 1'b1 : 1'b0;
    end
endmodule

module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);
    reg [7:0] prev_in;
    wire [7:0] edge;

    EdgeDetector edge_det[7:0] (
       .current(in),
       .previous(prev_in),
       .edge(edge)
    );

    always @(posedge clk) begin
        prev_in <= in;
        anyedge <= edge;
    end
endmodule