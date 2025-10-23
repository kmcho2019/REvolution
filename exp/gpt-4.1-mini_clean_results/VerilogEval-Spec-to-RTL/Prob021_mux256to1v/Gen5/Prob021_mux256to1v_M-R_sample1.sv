module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Directly index the 4-bit segment from 'in' based on 'sel'
    assign out = in[sel*4 +: 4];

endmodule