module TopModule(
    input [2:0] vec,  // 3-bit input vector
    output [2:0] outv,  // 3-bit output vector
    output o2,  // 1-bit output
    output o1,  // 1-bit output
    output o0  // 1-bit output
);

assign outv = vec;  // directly connect input vec to output outv
assign o0 = vec[0];  // connect o0 to the least significant bit of vec
assign o1 = vec[1];  // connect o1 to the middle bit of vec
assign o2 = vec[2];  // connect o2 to the most significant bit of vec

endmodule