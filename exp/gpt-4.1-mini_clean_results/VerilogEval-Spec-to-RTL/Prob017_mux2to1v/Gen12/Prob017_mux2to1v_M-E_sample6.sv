module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Create a 100-bit mask from sel
    wire [99:0] sel_mask = {100{sel}};

    // out = (a & ~sel_mask) | (b & sel_mask)
    assign out = (a & ~sel_mask) | (b & sel_mask);
endmodule