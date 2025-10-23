module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    wire [7:0] sel_mask = {8{sel}};
    assign out = (a & ~sel_mask) | (b & sel_mask);

endmodule