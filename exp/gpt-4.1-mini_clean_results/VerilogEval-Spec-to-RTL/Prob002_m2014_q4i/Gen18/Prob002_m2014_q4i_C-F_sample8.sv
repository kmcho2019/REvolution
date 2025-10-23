module TopModule(output out);
  // Directly drive output to constant logic 0 for minimal area, power, and timing.
  // Synthesizers typically infer a constant generator cell or tie the net to ground.
  // If supported, synthesis attributes or constraints can ensure usage of dedicated constant cells.
  assign out = 1'b0;
endmodule