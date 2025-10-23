module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly assign the 3-bit vector output as is
    assign outv = vec;

    // Assign single bit outputs with reversed order compared to vec indices
    assign o2 = vec[0];
    assign o1 = vec[1];
    assign o0 = vec[2];

endmodule