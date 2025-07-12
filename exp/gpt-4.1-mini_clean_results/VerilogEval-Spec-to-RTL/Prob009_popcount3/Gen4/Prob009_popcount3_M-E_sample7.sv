module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire sum0;
    wire carry0;

    // Add in[0] and in[1]
    assign sum0 = in[0] ^ in[1];
    assign carry0 = in[0] & in[1];

    // Add sum0 and in[2]
    assign out[0] = sum0 ^ in[2];
    assign out[1] = (sum0 & in[2]) | carry0;

endmodule