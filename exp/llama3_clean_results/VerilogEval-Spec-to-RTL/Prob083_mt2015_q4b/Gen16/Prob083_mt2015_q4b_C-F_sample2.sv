module TopModule(
    input x,
    input y,
    output logic z
);
    // The output z is 1 when x and y are the same (both 0 or both 1), and 0 when they are different.
    // This is implemented using the expression ~(x ^ y), which is a bitwise XOR followed by a bitwise NOT.
    assign z = ~(x ^ y);
endmodule