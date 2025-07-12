module TopModule(
    input  in,
    output out
);

// The current implementation is optimal for its simplicity.
// However, to further optimize for PPA, we could consider using attributes
// recognized by synthesis tools to provide hints for optimization.
// For instance, if the tool supports it, we could specify attributes to
// prioritize area or power reduction. However, such attributes are tool-specific
// and may not be universally applicable.

assign out = in;

endmodule