module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
    out = (!a && !c && (d || !d)) || // Grouping cd=00 and cd=01 for ab=00
          (a && !b && !c && (d || !d)) || // Grouping cd=00 and cd=01 for ab=10
          (a && b && c && (d || !d)) || // Grouping cd=11 for ab=11
          (b && !c && d) || // Handling the remaining term
          (!a && b && !c && !d) || // Handling the remaining term
          (a && !b && c && !d); // Handling the remaining term

endmodule