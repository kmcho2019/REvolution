module TopModule(
    input a,
    input b,
    input c,
    output out
);

assign out = a || (b || c);

// Alternatively, an explicit formulation could be considered:
// assign out = a | (b | c); // This is functionally equivalent to the above

// Or, for clarity and potential synthesis advantages:
// assign out = a | b | c; // Directly implementing the logic without nesting

endmodule