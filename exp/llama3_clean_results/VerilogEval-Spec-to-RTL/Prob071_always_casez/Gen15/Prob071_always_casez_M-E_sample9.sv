module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    wire [7:0] tmp;
    assign tmp = in;

    // Isolate the first '1' bit
    assign pos[0] = tmp[1] | tmp[2] | tmp[3] | tmp[4] | tmp[5] | tmp[6] | tmp[7];
    assign pos[1] = tmp[2] | tmp[3] | tmp[4] | tmp[5] | tmp[6] | tmp[7];
    assign pos[2] = tmp[4] | tmp[5] | tmp[6] | tmp[7];

endmodule