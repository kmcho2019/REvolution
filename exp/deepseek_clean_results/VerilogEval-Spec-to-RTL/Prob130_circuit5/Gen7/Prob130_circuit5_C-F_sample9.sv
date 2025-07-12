module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Selection signals for valid cases
wire select_b = (c == 4'd0);
wire select_e = (c == 4'd1);
wire select_a = (c == 4'd2);
wire select_d = (c == 4'd3);

// Default case when c > 3 (just check MSB for efficiency)
wire default_case = c[3] || (c[2] && |c[1:0]);

// Output selection using efficient bitwise operations
assign q = default_case ? 4'b1111 :
           (select_b ? b :
           (select_e ? e :
           (select_a ? a :
           d)));

endmodule