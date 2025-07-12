module TopModule(
    input x,
    input y,
    output z
);

    // Internal wires to connect the logic gates
    wire not_x;
    wire not_y;
    wire and1;
    wire and2;
    wire or_result;

    // Implement the NOT gates
    assign not_x = ~x;
    assign not_y = ~y;

    // Implement the AND gates
    assign and1 = x && not_y;
    assign and2 = not_x && y;

    // Implement the OR gate
    assign or_result = and1 || and2;

    // Final output is the NOT of the OR result
    assign z = ~or_result;

endmodule