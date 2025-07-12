// Refactored 8-bit 2-to-1 multiplexer implementation using an always block
module TopModule (
    // Select line input
    input        sel,
    // 8-bit input a
    input  [7:0] a,
    // 8-bit input b
    input  [7:0] b,
    // 8-bit output selected based on sel
    output [7:0] out
);

    // Use an always block to implement the multiplexer logic
    always @(*)
    begin
        if (sel)
            out = b; // If sel is high, select input b
        else
            out = a; // If sel is low, select input a
    end

endmodule