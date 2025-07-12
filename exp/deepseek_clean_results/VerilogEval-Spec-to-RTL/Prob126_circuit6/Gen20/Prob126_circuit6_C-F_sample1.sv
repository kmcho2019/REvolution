module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Output value parameters for each input case
localparam [15:0] OUT_0 = 16'h1232;
localparam [15:0] OUT_1 = 16'haee0;
localparam [15:0] OUT_2 = 16'h27d4;
localparam [15:0] OUT_3 = 16'h5a0e;
localparam [15:0] OUT_4 = 16'h2066;
localparam [15:0] OUT_5 = 16'h64ce;
localparam [15:0] OUT_6 = 16'hc526;
localparam [15:0] OUT_7 = 16'h2f19;

// Combinational output selection
assign q = (a == 3'd0) ? OUT_0 :
           (a == 3'd1) ? OUT_1 :
           (a == 3'd2) ? OUT_2 :
           (a == 3'd3) ? OUT_3 :
           (a == 3'd4) ? OUT_4 :
           (a == 3'd5) ? OUT_5 :
           (a == 3'd6) ? OUT_6 :
           (a == 3'd7) ? OUT_7 :
           16'h0000; // default case (unreachable for 3-bit input)

endmodule