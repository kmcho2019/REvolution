module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Equality comparisons
wire match_0 = (c == 4'd0);
wire match_1 = (c == 4'd1);
wire match_2 = (c == 4'd2);
wire match_3 = (c == 4'd3);

// Priority selection
wire sel_b = match_0;
wire sel_e = ~match_0 & match_1;
wire sel_a = ~match_0 & ~match_1 & match_2;
wire sel_d = ~match_0 & ~match_1 & ~match_2 & match_3;
wire sel_f = ~(match_0 | match_1 | match_2 | match_3);

// Output selection
assign q = (sel_b ? b :
           sel_e ? e :
           sel_a ? a :
           sel_d ? d :
           4'b1111);

endmodule