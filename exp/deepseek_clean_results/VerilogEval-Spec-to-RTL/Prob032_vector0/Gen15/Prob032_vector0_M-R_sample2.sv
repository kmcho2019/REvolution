module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Vector pass-through
    assign outv[2:0] = vec[2:0];
    
    // Bit splitting
    assign {o2, o1, o0} = vec[2:0];

endmodule