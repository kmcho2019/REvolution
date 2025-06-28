module TopModule (
  input a,
  input b,
  output out
);

wire or_output;

assign out = ~ (a | b);

endmodule