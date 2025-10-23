module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Direct vector output - clear and concise
    assign outv = vec;
    
    // Explicit individual bit assignments - most readable and maintainable
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];

endmodule