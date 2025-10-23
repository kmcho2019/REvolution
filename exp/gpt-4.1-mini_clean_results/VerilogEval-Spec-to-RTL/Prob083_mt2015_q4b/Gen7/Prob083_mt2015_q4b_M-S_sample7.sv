module TopModule(
    input  wire x,
    input  wire y,
    output wire z
);
    // Output z is 1 when x equals y, else 0
    assign z = ~(x ^ y);
endmodule