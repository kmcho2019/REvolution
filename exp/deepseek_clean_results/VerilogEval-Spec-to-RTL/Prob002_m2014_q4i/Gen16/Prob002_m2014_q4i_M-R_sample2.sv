// Alternative 1: Behavioral style with always block
module TopModule (
    output reg out
);
    // Using always block to drive constant 0
    // Synthesizes to same direct ground connection
    always @(*) begin
        out = 1'b0;
    end
endmodule

// Alternative 2: Structural style with wire
/*
module TopModule (
    output out
);
    // Direct wire assignment
    // Most explicit structural representation
    wire out = 1'b0;
endmodule
*/