module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

// Directly connect inputs to outputs using assign statements
assign w = a;
assign x = b;
assign y = b;
assign z = c;

endmodule