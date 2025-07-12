// Intermediate module to concatenate two input vectors
module ConcatModule(
    input  [4:0] a,
    input  [4:0] b,
    output [9:0] out
);
    assign out = {a, b};
endmodule

// Intermediate module to split a concatenated vector into two output vectors
module SplitModule(
    input  [9:0] in_vector,
    output [7:0] out_w,
    output [7:0] out_x
);
    assign out_w = in_vector[9:2];
    assign out_x = {in_vector[1:0], 6'b11}; // appending two 1 bits
endmodule

// TopModule utilizing the intermediate modules
module TopModule(
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);
    wire [9:0] ab;
    wire [9:0] cd;
    wire [9:0] ef;
    wire [9:0] wx;
    wire [9:0] yz;
    
    ConcatModule ab_concat(a, b);
    assign ab = ab_concat.out;
    
    ConcatModule cd_concat(c, d);
    assign cd = cd_concat.out;
    
    ConcatModule ef_concat(e, f);
    assign ef = ef_concat.out;
    
    // Further concatenation of ab and cd to form wx, and ef to form yz
    assign wx = {ab[7:0], cd[9:8]};
    assign yz = {cd[7:0], ef};
    
    SplitModule wx_split(wx, w, x);
    SplitModule yz_split(yz, y, z);
    
endmodule