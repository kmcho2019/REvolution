module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Select 4 bits starting at offset sel*4 in 'in' using indexed part-select
    assign out = in[sel*4 +: 4];
endmodule