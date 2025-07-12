module TopModule(
    input  in,
    output out
);
    // This module implements a simple NOT gate, inverting the input and assigning it to the output.
    // The NOT gate's functionality is achieved through a direct assign statement.
    assign out = ~in;
endmodule