module TopModule(
    input x,
    input y,
    output z
);
    // Internal wires to hold the results of AND operations
    wire both_high;
    wire both_low;

    // Check when both x and y are high
    and and_high(x, y, both_high);

    // Check when both x and y are low (using NOT gates to invert x and y)
    wire not_x, not_y;
    not inv_x(x, not_x);
    not inv_y(y, not_y);
    and and_low(not_x, not_y, both_low);

    // Use an OR gate to combine the conditions
    or or_gate(both_high, both_low, z);
endmodule