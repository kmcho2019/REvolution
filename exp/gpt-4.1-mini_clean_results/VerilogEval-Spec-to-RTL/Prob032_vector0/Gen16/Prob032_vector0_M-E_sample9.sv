module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Assign outv as a reversed concatenation of vec bits: bit 0 becomes MSB, bit 2 LSB
    assign outv = {vec[0], vec[1], vec[2]};

    // Individual bit outputs directly mapped from vec bits
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule