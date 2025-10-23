module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a | b); // Using NOR logic directly, ~ represents NOT, | represents OR

endmodule