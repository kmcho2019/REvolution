module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

wire [3:0] b_mask = {4{c == 4'b0000}};
wire [3:0] e_mask = {4{c == 4'b0001}};
wire [3:0] a_mask = {4{c == 4'b0010}};
wire [3:0] d_mask = {4{c == 4'b0011}};
wire default_case = |(c & 4'b1100) || (c > 4'b0011);

assign q = default_case ? 4'b1111 : 
           (b & b_mask) | 
           (e & e_mask) | 
           (a & a_mask) | 
           (d & d_mask);

endmodule