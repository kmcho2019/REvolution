module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Equivalent to: out = (~sel & a) | (sel & b)
    assign out = (a & {100{~sel}}) | (b & {100{sel}});

endmodule