module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Direct vector output
    assign outv = vec;
    
    // Individual bit outputs with explicit bit selection
    assign {o2, o1, o0} = vec;

endmodule