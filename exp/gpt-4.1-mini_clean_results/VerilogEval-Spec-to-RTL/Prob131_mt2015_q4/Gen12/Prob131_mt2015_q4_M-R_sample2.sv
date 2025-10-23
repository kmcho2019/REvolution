module TopModule(input wire x, input wire y, output wire z);
    // Define logic for module A: (x ^ y) & x
    wire a_out1 = (x ^ y) & x;
    wire a_out2 = (x ^ y) & x;

    // Define logic for module B: ~(x ^ y)
    wire b_out1 = ~(x ^ y);
    wire b_out2 = ~(x ^ y);

    // Combine first pair outputs with OR
    wire or_out = a_out1 | b_out1;

    // Combine second pair outputs with AND
    wire and_out = a_out2 & b_out2;

    // Final output is XOR of or_out and and_out
    assign z = or_out ^ and_out;
endmodule