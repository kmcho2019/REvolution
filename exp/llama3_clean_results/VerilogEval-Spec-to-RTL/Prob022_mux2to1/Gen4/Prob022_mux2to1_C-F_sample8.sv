module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

// Using ternary operator for concise and efficient implementation
assign out = sel? b : a;

endmodule