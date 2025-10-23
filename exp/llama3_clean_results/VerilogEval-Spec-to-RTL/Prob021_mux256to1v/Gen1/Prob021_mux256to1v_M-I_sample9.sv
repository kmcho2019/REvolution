module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// The existing design is already efficient. However, to further optimize,
// we can consider using synthesis attributes to guide the tool, though
// this might not be directly applicable in all synthesis environments.
// For instance, if the target technology has specific multiplexer resources,
// we could attempt to map our logic onto those, but such optimizations
// are highly technology-dependent.

assign out = in[(sel * 4) +: 4];

endmodule