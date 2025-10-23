module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Directly implementing the Karnaugh map's logic with a simple OR operation
// Since the logic is straightforward, explicit gate-level implementation might not offer significant improvements
assign out = a | b | c;

// Alternatively, for explicitness, though unlikely to yield better PPA:
// assign out = (a | b) | c; // This does not seem to offer any improvement over the direct OR operation

endmodule