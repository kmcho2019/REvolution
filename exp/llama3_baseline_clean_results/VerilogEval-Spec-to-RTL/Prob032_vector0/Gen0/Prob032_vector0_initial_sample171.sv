module TopModule (
    input  [2:0] vec,  // 3-bit input vector
    output [2:0] outv, // 3-bit output vector
    output o2,         // output bit connected to vec[2]
    output o1,         // output bit connected to vec[1]
    output o0          // output bit connected to vec[0]
);

assign outv = vec;    // connect vec directly to outv
assign o2 = vec[2];   // connect vec[2] to o2
assign o1 = vec[1];   // connect vec[1] to o1
assign o0 = vec[0];   // connect vec[0] to o0

endmodule