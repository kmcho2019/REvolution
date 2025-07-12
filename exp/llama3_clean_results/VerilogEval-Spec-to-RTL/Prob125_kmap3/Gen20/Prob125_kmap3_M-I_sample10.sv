module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Ignored due to don't-care condition
    output out
);

assign out = a || (!a &&!b && c);

// Alternative expression for readability and potential synthesis optimization
// assign out = (a) || (!a &&!b && c);

endmodule