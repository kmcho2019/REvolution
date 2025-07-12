module refactored_top_level(x, y, z);
    input x, y;
    output z;

    wire a, b, or_out, and_out;

    // Calculate the output of Module A
    assign a = (x ^ y) & x;

    // Calculate the output of Module B
    assign b = ~x & ~y | x & y;

    // Calculate the output of the OR gate
    assign or_out = a | b;

    // Calculate the output of the AND gate
    assign and_out = a & b;

    // Calculate the final output z
    assign z = or_out ^ and_out;
endmodule