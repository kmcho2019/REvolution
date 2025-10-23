module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    wire [7:0] sel_vec = {8{sel}};
    assign out = (a & ~sel_vec) | (b & sel_vec);

endmodule