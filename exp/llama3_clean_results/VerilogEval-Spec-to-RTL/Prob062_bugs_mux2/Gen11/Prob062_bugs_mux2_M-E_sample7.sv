// Novel 8-bit 2-to-1 multiplexer implementation using a case statement
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

    // Use a case statement to assign the output based on the select line
    always @(sel, a, b) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = 8'b0; // Default case to prevent latches
        endcase
    end

endmodule