module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);
    // Direct combinational selection using indexed vector access
    assign out = in[sel];
endmodule