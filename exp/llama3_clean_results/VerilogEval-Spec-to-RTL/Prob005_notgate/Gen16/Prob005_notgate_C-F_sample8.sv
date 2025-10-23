module TopModule(
    input  in,
    output out
);
    // This module implements a simple NOT gate using a continuous assignment.
    assign out = ~in; // Inverts the input and assigns it to the output.
endmodule