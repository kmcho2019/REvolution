module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

wire select_b = (c == 4'b0000);
wire select_e = (c == 4'b0001);
wire select_a = (c == 4'b0010);
wire select_d = (c == 4'b0011);
wire default_case = (c > 4'b0011);

assign q = default_case ? 4'b1111 :
           select_b ? b :
           select_e ? e :
           select_a ? a :
           d;  // Last case covers c == 3

endmodule