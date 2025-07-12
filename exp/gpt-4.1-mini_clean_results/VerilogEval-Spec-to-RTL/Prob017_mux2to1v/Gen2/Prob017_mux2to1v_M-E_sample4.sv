module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

wire [99:0] sel_mask = {100{sel}};
wire [99:0] sel_inv_mask = ~sel_mask;

assign out = (a & sel_inv_mask) | (b & sel_mask);

endmodule