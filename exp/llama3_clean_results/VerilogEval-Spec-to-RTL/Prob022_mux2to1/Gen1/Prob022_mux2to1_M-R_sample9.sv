module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

    assign out = (sel == 1'b0)? a : b; // Original Implementation
    // Refactored Implementation using basic logic gates
    // assign out = (a & ~sel) | (b & sel);

    // Explicitly defining the logic for clarity
    wire not_sel;
    assign not_sel = ~sel;
    assign out = (a & not_sel) | (b & sel);

endmodule