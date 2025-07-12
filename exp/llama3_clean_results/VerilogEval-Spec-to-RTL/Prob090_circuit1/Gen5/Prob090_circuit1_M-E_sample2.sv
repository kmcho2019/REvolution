module TopModule(
    input  a,
    input  b,
    output q
);

    // Invert inputs
    wire a_inv;
    assign a_inv = ~a;

    wire b_inv;
    assign b_inv = ~b;

    // Apply inverted inputs to NOR gate
    wire nor_output;
    assign nor_output = ~(a_inv | b_inv);

    // Invert NOR output to get AND functionality
    assign q = nor_output;

endmodule