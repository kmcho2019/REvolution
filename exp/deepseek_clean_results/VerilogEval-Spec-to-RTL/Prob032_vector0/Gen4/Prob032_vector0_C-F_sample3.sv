module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Direct vector output assignment
    assign outv = vec;
    
    // Concise bit output assignment showing explicit mapping
    assign {o2, o1, o0} = vec[2:0];

endmodule