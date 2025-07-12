// Module declaration for TopModule, a simple NOT gate implementation
module TopModule(
    input  in,  // Input signal to the NOT gate
    output out  // Output signal from the NOT gate
);
    // Direct implementation of a NOT gate using assign statement
    // This is the most straightforward and efficient way to implement a NOT gate in Verilog
    assign out = ~in;  // Invert the input signal and assign it to the output
endmodule