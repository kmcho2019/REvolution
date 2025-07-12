module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [15:0] q0 = (a == 3'd0) ? 16'h1232 : 16'h0;
wire [15:0] q1 = (a == 3'd1) ? 16'haee0 : 16'h0;
wire [15:0] q2 = (a == 3'd2) ? 16'h27d4 : 16'h0;
wire [15:0] q3 = (a == 3'd3) ? 16'h5a0e : 16'h0;
wire [15:0] q4 = (a == 3'd4) ? 16'h2066 : 16'h0;
wire [15:0] q5 = (a == 3'd5) ? 16'h64ce : 16'h0;
wire [15:0] q6 = (a == 3'd6) ? 16'hc526 : 16'h0;
wire [15:0] q7 = (a == 3'd7) ? 16'h2f19 : 16'h0;

assign q = q0 | q1 | q2 | q3 | q4 | q5 | q6 | q7;

endmodule