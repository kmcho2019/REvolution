module TopModule(
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
    );
    
    assign outv = vec;
    assign o2 = outv[2];
    assign o1 = outv[1];
    assign o0 = outv[0];

endmodule