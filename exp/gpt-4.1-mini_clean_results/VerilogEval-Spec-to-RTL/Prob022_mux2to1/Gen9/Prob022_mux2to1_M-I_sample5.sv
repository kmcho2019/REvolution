module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

assign out = (~sel & a) | (sel & b);

endmodule