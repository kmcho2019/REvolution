module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    wire bit0, bit1, bit2;

    assign bit0 = in[0];
    assign bit1 = in[1];
    assign bit2 = in[2];

    assign out = bit0 + bit1 + bit2;

endmodule