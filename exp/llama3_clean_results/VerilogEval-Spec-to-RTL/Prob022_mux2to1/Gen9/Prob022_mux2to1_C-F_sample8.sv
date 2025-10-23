module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);
// Direct and concise assignment using the ternary operator
assign out = sel ? b : a;
endmodule