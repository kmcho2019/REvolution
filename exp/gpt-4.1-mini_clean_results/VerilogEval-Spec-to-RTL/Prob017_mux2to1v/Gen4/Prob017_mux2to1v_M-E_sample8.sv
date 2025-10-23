module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    wire [99:0] sel_mask;
    wire [99:0] sel_inv_mask;

    assign sel_mask = {100{sel}};      // replicate sel to 100 bits
    assign sel_inv_mask = ~sel_mask;  // invert replicated sel bits

    assign out = (a & sel_inv_mask) | (b & sel_mask);
endmodule