module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Implement mux using bitwise operations:
    // out = (a & ~sel) | (b & sel)
    assign out = (a & {100{~sel}}) | (b & {100{sel}});
endmodule