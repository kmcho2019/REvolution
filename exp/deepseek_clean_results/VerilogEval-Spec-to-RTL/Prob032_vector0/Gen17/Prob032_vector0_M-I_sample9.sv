module TopModule (
    input [2:0] vec,
    input output_en,    // Output enable control
    output [2:0] outv,
    output o2, o1, o0
);
    
    // Parameter for potential width scaling
    parameter WIDTH = 3;
    
    // Output assignments with enable control
    assign outv = output_en ? vec : {WIDTH{1'b0}};
    assign o2 = output_en ? vec[2] : 1'b0;
    assign o1 = output_en ? vec[1] : 1'b0;
    assign o0 = output_en ? vec[0] : 1'b0;

endmodule