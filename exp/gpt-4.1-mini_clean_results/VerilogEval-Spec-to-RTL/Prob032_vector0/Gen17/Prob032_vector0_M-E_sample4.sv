module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly connect outv to vec for zero-overhead vector forwarding
    assign outv = vec;

    // Explicitly assign single-bit outputs from respective positions of vec
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule