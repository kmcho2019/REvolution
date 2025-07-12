module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Assign individual bits
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];
    
    // Construct vector output from bits
    assign outv = {o2, o1, o0};

endmodule