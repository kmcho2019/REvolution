module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Population count of 3 bits: count number of '1's in input
    // out[1] (MSB) indicates if count >= 2 (majority),
    // out[0] (LSB) is parity (odd number of '1's),
    // together they represent the total count in binary (0 to 3).
    assign out = in[0] + in[1] + in[2];

endmodule