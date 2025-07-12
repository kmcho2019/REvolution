module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [8:0] temp;

    assign temp = {a[7], a} + {b[7], b};
    assign s = temp[7:0];
    assign overflow = temp[8] ^ temp[7];

endmodule