module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

wire is_case0 = (c == 4'b0000);
wire is_case1 = (c == 4'b0001);
wire is_case2 = (c == 4'b0010);
wire is_case3 = (c == 4'b0011);
wire default_case = (c > 4'b0011);

assign q = default_case ? 4'b1111 :
           (is_case0 ? b :
           (is_case1 ? e :
           (is_case2 ? a :
           d)));

endmodule