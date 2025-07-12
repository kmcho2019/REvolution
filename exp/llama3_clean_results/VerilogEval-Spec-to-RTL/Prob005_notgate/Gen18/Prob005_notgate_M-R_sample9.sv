module TopModule(
    input  in,
    output reg out
);
    // This module implements a simple NOT gate, inverting the input and assigning it to the output.
    // The NOT gate's functionality is achieved through an always block with a sensitivity list.
    always @(*)
        out = ~in;
endmodule