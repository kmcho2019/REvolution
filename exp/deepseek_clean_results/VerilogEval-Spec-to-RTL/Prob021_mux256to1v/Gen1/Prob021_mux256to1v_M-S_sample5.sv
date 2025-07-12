module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    localparam WIDTH = 4;
    assign out = in[sel*WIDTH +: WIDTH];
endmodule