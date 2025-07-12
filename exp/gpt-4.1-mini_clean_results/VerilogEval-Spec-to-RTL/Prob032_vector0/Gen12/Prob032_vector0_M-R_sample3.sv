module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Directly assign the output vector from input
    assign outv = vec;

    // Split the vector bits directly using continuous assignments
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule