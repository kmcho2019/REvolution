// Superior solution combining the best ideas from both examples
module TopModule(
    input  in,
    output out
);

    // Direct implementation of a NOT gate using assign statement
    // This is the most concise and efficient way to implement a NOT gate
    assign out = ~in;

    // Alternatively, an always block can be used for more complex designs
    // This approach provides flexibility but is less concise for simple operations
    // reg out_always;
    // always @(*) begin
    //     out_always = ~in;
    // end

endmodule