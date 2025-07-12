module TopModule(
    input  in,
    output out
);
    // Implementing a NOT gate using a 2-to-1 multiplexer.
    // The inputs to the MUX are fixed as 0 and 1, and the input signal 'in' is used as the select line.
    // When 'in' is 0, the MUX selects the input connected to 1, and when 'in' is 1, it selects the input connected to 0, thus inverting the input.
    wire not_in;
    assign not_in = ~in;
    assign out = in? 0 : 1; // Using the ternary operator to simplify the MUX logic into a single line.
endmodule