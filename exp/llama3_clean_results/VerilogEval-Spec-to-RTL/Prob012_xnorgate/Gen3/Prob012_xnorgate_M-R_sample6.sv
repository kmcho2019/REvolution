module TopModule(
    input  a,
    input  b,
    output reg out
);
    
    // Refactored implementation using an always block for potential future expansions
    always @(*) begin
        out = ~(a ^ b); // Implementing XNOR by inverting the XOR of a and b
    end

endmodule