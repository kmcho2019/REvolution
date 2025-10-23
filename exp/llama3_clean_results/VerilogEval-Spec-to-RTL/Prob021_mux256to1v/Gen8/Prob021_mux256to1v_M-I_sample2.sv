module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // The assignment remains efficient and is a good starting point.
    // However, to potentially improve PPA metrics, we could consider adding pipeline stages or other optimization techniques.
    // For simplicity and given the already efficient nature of the current implementation, we'll focus on minor adjustments.
    assign out = in[(sel * 4) +: 4];

    // Considerations for future optimization could include:
    // - Pipeline stages for improved timing, if the current implementation proves to be on the critical path.
    // - Clock gating or similar power reduction techniques, especially if the input data patterns allow for significant power savings.
    // - Further simplification or reorganization of the logic, though the current design is quite minimalist.

endmodule