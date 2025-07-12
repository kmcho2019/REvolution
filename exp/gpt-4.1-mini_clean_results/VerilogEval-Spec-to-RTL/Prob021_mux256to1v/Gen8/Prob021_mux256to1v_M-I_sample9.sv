module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Directly select 4 bits from 'in' based on sel:
    // sel=0 picks in[3:0], sel=1 picks in[7:4], etc.
    assign out = in[sel*4 +: 4];

endmodule