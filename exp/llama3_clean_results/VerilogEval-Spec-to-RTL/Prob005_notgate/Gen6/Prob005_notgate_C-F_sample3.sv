// Module: TopModule
// Description: Implements a basic digital NOT gate using a continuous assignment.
//              The input 'in' is inverted to produce the output 'out'.

module TopModule(
    input  in,  // Input signal to be inverted
    output out  // Inverted output signal
);

    // Use a continuous assignment to implement the NOT gate
    // This method is concise and efficient for simple combinational logic.
    assign out = ~in;  // Invert the input signal to produce the output

endmodule