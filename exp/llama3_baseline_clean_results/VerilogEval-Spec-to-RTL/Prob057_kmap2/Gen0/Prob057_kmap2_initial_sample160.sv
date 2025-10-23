module TopModule(a, b, c, d, out);
  input a;
  input b;
  input c;
  input d;
  output out;

  // Deriving SOP form from the Karnaugh map:
  // Minterms where out = 1: abcd = 0000, 0001, 0010, 0011, 0111, 1000, 1001, 1010, 1111
  // However, directly implementing all these terms would be cumbersome and might not reflect the optimized logic from the Karnaugh map.
  // Observing the map, we can simplify it by considering the logic directly from the map's structure:
  // out is 1 when (a and b and not c and not d) or (not a and b and not c and d) or (not a and not b and c and not d) or (a and not b and c and not d) or (a and b and c and d) or (a and b and not c and d).
  assign out = (a && b && !c && !d) || (!a && b && !c && d) || (!a && !b && c && !d) || (a && !b && c && !d) || (a && b && c && d) || (a && b && !c && d);

endmodule