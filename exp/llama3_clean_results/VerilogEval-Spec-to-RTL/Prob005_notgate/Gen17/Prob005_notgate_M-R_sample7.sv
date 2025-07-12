module TopModule(
    input  in,
    output reg out
);
    // This module implements a simple NOT gate using an always block.
    always @(*) begin
        out = ~in; // Inverts the input and assigns it to the output.
    end
endmodule