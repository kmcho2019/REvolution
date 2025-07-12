module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

wire select_b = (c == 4'd0);
wire select_e = (c == 4'd1);
wire select_a = (c == 4'd2);
wire select_d = (c == 4'd3);
wire default_case = (c > 4'd3);

assign q = default_case ? 4'b1111 :
           (b & {4{select_b}}) |
           (e & {4{select_e}}) |
           (a & {4{select_a}}) |
           (d & {4{select_d}});

endmodule