module TopModule(
    input  in,
    output out
);

assign out = ~in;  // Using ~ operator to invert the input

endmodule