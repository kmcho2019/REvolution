module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Replicate sel to create a 100-bit mask
    wire [99:0] sel_mask = {100{sel}};
    // Implement mux using bitwise AND/OR with mask
    assign out = ( (~sel_mask) & a ) | ( sel_mask & b );
endmodule