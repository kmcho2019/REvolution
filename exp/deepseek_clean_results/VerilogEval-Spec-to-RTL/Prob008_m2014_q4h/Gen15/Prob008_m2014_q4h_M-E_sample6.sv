module TopModule(input in, output out);
  // Transmission gate implementation with always-on enable
  tranif1 tg1(out, in, 1'b1);  // NMOS pass transistor
  tranif0 tg2(out, in, 1'b0);  // PMOS pass transistor
endmodule