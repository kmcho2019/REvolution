// Module TopModule implements a novel 2-1 multiplexer using a tree-based structure.
// It selects between two 100-bit inputs, 'a' and 'b', based on the 'sel' input.
// When 'sel' is 0, 'a' is selected; when 'sel' is 1, 'b' is selected.

module TopModule(
    // 100-bit input vectors a and b
    input  [99:0] a,  
    input  [99:0] b,  
    // 1-bit select input sel
    input  sel,       
    // 100-bit output vector out
    output [99:0] out 
);

// The tree-based structure will consist of multiple levels of bitwise operations.
// Each level will reduce the number of inputs by half, eventually selecting between two inputs at the root.
wire [99:0] sel_a, sel_b;

// Level 1: Split inputs into two segments
assign sel_a[99:50] = sel ? b[99:50] : a[99:50];
assign sel_a[49:0]  = sel ? b[49:0]  : a[49:0];
assign sel_b[99:50] = sel ? a[99:50] : b[99:50];
assign sel_b[49:0]  = sel ? a[49:0]  : b[49:0];

// Level 2: Further split and select
wire [99:0] sel_c, sel_d;
assign sel_c[99:75] = sel_a[99:75] & ~sel_b[99:75] | ~sel_a[99:75] & sel_b[99:75];
assign sel_c[74:25] = sel_a[74:25]  & ~sel_b[74:25] | ~sel_a[74:25]  & sel_b[74:25];
assign sel_c[24:0]  = sel_a[24:0]   & ~sel_b[24:0]  | ~sel_a[24:0]   & sel_b[24:0];
assign sel_d[99:75] = sel_b[99:75] & ~sel_a[99:75] | ~sel_b[99:75] & sel_a[99:75];
assign sel_d[74:25] = sel_b[74:25]  & ~sel_a[74:25] | ~sel_b[74:25]  & sel_a[74:25];
assign sel_d[24:0]  = sel_b[24:0]   & ~sel_a[24:0]  | ~sel_b[24:0]   & sel_a[24:0];

// Output selection
assign out = sel_c;

endmodule