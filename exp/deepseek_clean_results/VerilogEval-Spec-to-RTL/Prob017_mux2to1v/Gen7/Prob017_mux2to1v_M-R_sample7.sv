module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    wire [99:0] sel_broadcast = {100{sel}};
    assign out = (~sel_broadcast & a) | (sel_broadcast & b);

endmodule