module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Priority selection logic
wire select_b = (c == 4'd0);
wire select_e = ~select_b & (c == 4'd1);
wire select_a = ~select_b & ~select_e & (c == 4'd2);
wire select_d = ~select_b & ~select_e & ~select_a & (c == 4'd3);
wire select_f = ~select_b & ~select_e & ~select_a & ~select_d;

// Output selection
assign q = select_b ? b :
           select_e ? e :
           select_a ? a :
           select_d ? d :
           4'b1111;

endmodule