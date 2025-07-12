module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Direct connection for vector output (clear intent)
    assign outv = vec;
    
    // Single assignment for bit outputs (compact and shows relationships)
    assign {o2, o1, o0} = vec;

endmodule