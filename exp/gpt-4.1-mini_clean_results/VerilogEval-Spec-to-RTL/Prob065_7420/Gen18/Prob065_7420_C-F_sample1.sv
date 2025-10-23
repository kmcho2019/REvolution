// Module: nand4
// Description: 4-input NAND gate replicating one of the two 4-input NAND gates in the 7420 chip
// Parameter KEEP_GATE allows synthesis attribute to preserve gate structure if desired
module nand4 #(
    parameter KEEP_GATE = 0  // Set to 1 to preserve gate during synthesis, 0 to allow optimization
)(
    input  a,  // First input
    input  b,  // Second input
    input  c,  // Third input
    input  d,  // Fourth input
    output y   // NAND output
);

    // Optional synthesis attribute applied conditionally via generate block
    generate
        if (KEEP_GATE) begin
            // synthesis attribute to keep gate structure
            (* keep = "true" *) wire y_internal;
            assign y_internal = ~(a & b & c & d);
            assign y = y_internal;
        end else begin
            assign y = ~(a & b & c & d);
        end
    endgenerate

endmodule

// Module: TopModule
// Description: Implements 7420 chip functionality with two independent 4-input NAND gates
module TopModule(
    input  p1a,  // First NAND gate inputs
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,  // Second NAND gate inputs
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,  // Output of first NAND gate
    output p2y   // Output of second NAND gate
);

    // Instantiate first 4-input NAND gate with synthesis preservation enabled
    nand4 #(.KEEP_GATE(1)) nand_gate1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Instantiate second 4-input NAND gate with synthesis preservation enabled
    nand4 #(.KEEP_GATE(1)) nand_gate2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule