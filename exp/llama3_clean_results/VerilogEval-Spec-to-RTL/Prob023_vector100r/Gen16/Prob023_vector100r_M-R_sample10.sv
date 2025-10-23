module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,  // Input vector
    output [WIDTH-1:0] out // Output vector (reversed input)
);

    // Use a continuous assignment to reverse the input vector
    assign out = {<< {WIDTH{1'b0}} >> {in}};

    // Alternatively, using a for loop to reverse the bits
    // This is not directly possible in Verilog with a simple assign statement
    // The following is a conceptual representation and not valid Verilog code
    // assign out = for (i = 0; i < WIDTH; i++) {in[WIDTH-1-i]};
    // However, the correct way to achieve this is by using the previous line or the original generate block approach.

endmodule