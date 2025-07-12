module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    wire [99:0] sel_mask = {100{sel}};
    assign out = (a & ~sel_mask) | (b & sel_mask);

endmodule