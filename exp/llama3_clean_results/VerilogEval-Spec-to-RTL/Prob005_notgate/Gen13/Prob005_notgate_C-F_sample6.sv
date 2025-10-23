// This module implements a simple NOT gate.
// The NOT gate's functionality is achieved through a continuous assignment,
// directly inverting the input and assigning it to the output.
module TopModule(
    input  in,
    output out
);
    assign out = ~in;
endmodule