module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Connect the 3-bit output directly to the input
    assign outv = vec;

    // Split the vector into individual bits
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];

endmodule