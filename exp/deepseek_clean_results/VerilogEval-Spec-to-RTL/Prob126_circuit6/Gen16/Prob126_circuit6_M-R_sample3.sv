module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] sel0 = (a == 3'd0) ? 16'h1232 : 16'd0;
wire [15:0] sel1 = (a == 3'd1) ? 16'haee0 : 16'd0;
wire [15:0] sel2 = (a == 3'd2) ? 16'h27d4 : 16'd0;
wire [15:0] sel3 = (a == 3'd3) ? 16'h5a0e : 16'd0;
wire [15:0] sel4 = (a == 3'd4) ? 16'h2066 : 16'd0;
wire [15:0] sel5 = (a == 3'd5) ? 16'h64ce : 16'd0;
wire [15:0] sel6 = (a == 3'd6) ? 16'hc526 : 16'd0;
wire [15:0] sel7 = (a == 3'd7) ? 16'h2f19 : 16'd0;

assign q = sel0 | sel1 | sel2 | sel3 | sel4 | sel5 | sel6 | sel7;

endmodule