module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Included for completeness, though 'd' is don't-care
    output out
);

wire temp1;
assign temp1 = (a && b) || (a && c);
assign out = temp1 || (!a && !b && c);

endmodule