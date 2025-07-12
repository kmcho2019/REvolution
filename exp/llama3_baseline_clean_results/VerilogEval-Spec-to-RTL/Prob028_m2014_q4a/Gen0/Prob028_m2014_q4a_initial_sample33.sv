module TopModule(d, ena, q);
  input d;
  input ena;
  output q;
  reg q; // Declare q as a reg type for internal use

  always @(d or ena) // Sensitivity list includes both d and ena
    if (ena) // If enable is high
      q <= d; // Update q with the current value of d

endmodule