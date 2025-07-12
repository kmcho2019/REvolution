module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Generate selection masks
wire [3:0] sel_b = {4{c == 4'd0}};
wire [3:0] sel_e = {4{c == 4'd1}};
wire [3:0] sel_a = {4{c == 4'd2}};
wire [3:0] sel_d = {4{c == 4'd3}};
wire [3:0] sel_f = {4{|c[3:2]}};  // Default case when c > 3

// Bitwise selection logic
assign q = (b & sel_b) | (e & sel_e) | (a & sel_a) | (d & sel_d) | (4'b1111 & sel_f);

endmodule