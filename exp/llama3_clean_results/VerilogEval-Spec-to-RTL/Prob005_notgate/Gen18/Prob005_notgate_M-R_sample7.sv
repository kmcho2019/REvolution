// TopModule: A simple Verilog module implementing a NOT gate using an always block.
module TopModule(
    input  in,  // Input signal to be inverted
    output reg out  // Output signal, inverted version of input
);

    // Implement the NOT gate using an always block with combinational logic sensitivity
    always @(*) begin
        // Invert the input signal and assign it to output
        out = ~in;
    end

endmodule