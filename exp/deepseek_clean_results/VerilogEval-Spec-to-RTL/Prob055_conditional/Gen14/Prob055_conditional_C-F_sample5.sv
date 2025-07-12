module Min2 #(parameter WIDTH = 8) (
    input [WIDTH-1:0] in0,
    input [WIDTH-1:0] in1,
    output [WIDTH-1:0] min_out
);
    assign min_out = (in0 < in1) ? in0 : in1;
endmodule

module TopModule #(parameter WIDTH = 8) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [WIDTH-1:0] c,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] min
);

    wire [WIDTH-1:0] min_ab, min_cd;
    
    // First level of parallel comparisons
    Min2 #(WIDTH) min_ab_inst (.in0(a), .in1(b), .min_out(min_ab));
    Min2 #(WIDTH) min_cd_inst (.in0(c), .in1(d), .min_out(min_cd));
    
    // Final comparison
    assign min = (min_ab < min_cd) ? min_ab : min_cd;

endmodule