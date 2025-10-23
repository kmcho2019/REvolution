module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Flattened 2-to-1 mux using bitwise operators for all bits
    assign out = (a & {100{~sel}}) | (b & {100{sel}});
endmodule