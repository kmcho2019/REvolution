module NOT_gate (
  input in,
  output out
);
  assign out = ~in;
endmodule

module TopModule (
  input in,
  output out
);
  NOT_gate not_gate_inst (
    .in(in),
    .out(out)
  );
endmodule