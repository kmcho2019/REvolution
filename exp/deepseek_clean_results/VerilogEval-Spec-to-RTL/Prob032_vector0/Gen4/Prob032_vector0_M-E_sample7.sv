module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Use buffer gates for each bit connection
    buf b2(o2, vec[2]);
    buf b1(o1, vec[1]);
    buf b0(o0, vec[0]);
    
    // Construct the vector output from buffered bits
    assign outv = {o2, o1, o0};

endmodule