module Min2 (
    input [7:0] in0,
    input [7:0] in1,
    output [7:0] min_out
);
    assign min_out = (in0 < in1) ? in0 : in1;
endmodule

module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    wire [7:0] min_ab, min_cd;
    
    // First level min modules
    Min2 min_ab_inst (.in0(a), .in1(b), .min_out(min_ab));
    Min2 min_cd_inst (.in0(c), .in1(d), .min_out(min_cd));
    
    // Final min module
    Min2 final_min_inst (.in0(min_ab), .in1(min_cd), .min_out(min));

endmodule