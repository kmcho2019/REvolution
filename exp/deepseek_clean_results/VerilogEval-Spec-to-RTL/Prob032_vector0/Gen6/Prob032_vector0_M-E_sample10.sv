module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Direct vector pass-through
    assign outv = vec;

    // Structural bit extraction
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];

endmodule