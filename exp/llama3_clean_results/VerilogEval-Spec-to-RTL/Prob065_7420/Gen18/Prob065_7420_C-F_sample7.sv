// Define a reusable module for a dual 4-input NAND gate with optimization directives
module DualNAND4(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

// Use synthesis directives for area optimization
// (* area_optimization = "high" *)
// Assign p1y as the negation of the conjunction of p1a, p1b, p1c, and p1d
assign p1y = ~(p1a & p1b & p1c & p1d);

// Assign p2y as the negation of the conjunction of p2a, p2b, p2c, and p2d
assign p2y = ~(p2a & p2b & p2c & p2d);

// Consider adding synthesis directives for timing and power optimization
// (* timing_optimization = "high" *)
// (* power_optimization = "high" *)

endmodule

// Instantiate the DualNAND4 module within the TopModule
module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

// Instantiate the DualNAND4 module
DualNAND4 dual_nand(
  .p1a(p1a),
  .p1b(p1b),
  .p1c(p1c),
  .p1d(p1d),
  .p2a(p2a),
  .p2b(p2b),
  .p2c(p2c),
  .p2d(p2d),
  .p1y(p1y),
  .p2y(p2y)
);

endmodule