module TopModule(
    input  [2:0] in,  // input vector of 3 bits
    output [1:0] out  // output vector of 2 bits
);

    assign out = in[0] + in[1] + in[2];

endmodule