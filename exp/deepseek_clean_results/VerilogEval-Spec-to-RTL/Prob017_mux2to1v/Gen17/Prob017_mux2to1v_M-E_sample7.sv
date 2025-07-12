module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    wire [99:0] sel_mask = {100{sel}};  // Replicate sel bit 100 times
    wire [99:0] a_selected = a & ~sel_mask;
    wire [99:0] b_selected = b & sel_mask;
    
    assign out = a_selected | b_selected;

endmodule