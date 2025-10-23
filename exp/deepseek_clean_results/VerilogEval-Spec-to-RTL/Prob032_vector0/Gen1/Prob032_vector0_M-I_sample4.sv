module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Vector output - pass through entire 3-bit input
    assign outv[2] = vec[2];
    assign outv[1] = vec[1];
    assign outv[0] = vec[0];

    // Individual bit outputs - split from input vector
    assign o2 = vec[2];  // MSB
    assign o1 = vec[1];
    assign o0 = vec[0];  // LSB

endmodule