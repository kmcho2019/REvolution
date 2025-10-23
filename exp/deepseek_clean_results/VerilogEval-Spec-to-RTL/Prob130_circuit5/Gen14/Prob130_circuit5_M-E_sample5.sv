module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Detect valid cases
wire select_b = (c == 4'd0);
wire select_e = (c == 4'd1);
wire select_a = (c == 4'd2);
wire select_d = (c == 4'd3);

// Handle invalid cases (c >= 4)
wire invalid = (c > 4'd3);

// Bitwise selection with priority
assign q = (select_b ? b :
           (select_e ? e :
           (select_a ? a :
           (select_d ? d : 4'b1111))));

endmodule