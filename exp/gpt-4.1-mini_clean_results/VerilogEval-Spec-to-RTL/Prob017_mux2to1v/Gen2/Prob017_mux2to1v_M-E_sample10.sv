module TopModule(
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);
    wire [99:0] sel_mask = {100{sel}};       // replicate sel to 100 bits
    wire [99:0] nsel_mask = ~sel_mask;       // invert sel_mask

    assign out = (a & nsel_mask) | (b & sel_mask);
endmodule