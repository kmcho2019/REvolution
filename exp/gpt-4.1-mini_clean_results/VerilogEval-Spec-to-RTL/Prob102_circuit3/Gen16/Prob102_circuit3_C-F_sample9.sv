module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);

    // Intermediate signals as localparams for clarity and synthesis optimization
    localparam or_ab = 1'b0; // placeholder; will be overridden by continuous assign
    localparam or_cd = 1'b0;

    wire or_ab_wire = a | b;
    wire or_cd_wire = c | d;

    // Output is AND of OR terms, referencing the named intermediate wires
    assign q = or_ab_wire & or_cd_wire;

endmodule