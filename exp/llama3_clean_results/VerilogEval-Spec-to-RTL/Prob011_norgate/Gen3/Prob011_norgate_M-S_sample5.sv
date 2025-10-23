module TopModule(
    input  a,
    input  b,
    output out
);
// Directly implement NOR gate logic using assign statement
assign out = ~(a | b);
endmodule