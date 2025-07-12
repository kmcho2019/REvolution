module TopModule (
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    // Implement mux with bitwise masking to reduce switching and potentially lower power
    assign out = (~{100{sel}} & a) | ({100{sel}} & b);
endmodule