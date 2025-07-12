module TopModule(
    input  in,
    output reg out
);
    // This module implements a simple NOT gate using an always block.
    // The NOT gate's functionality is achieved through procedural assignment.
    always @(*) begin
        out = ~in;
    end
endmodule