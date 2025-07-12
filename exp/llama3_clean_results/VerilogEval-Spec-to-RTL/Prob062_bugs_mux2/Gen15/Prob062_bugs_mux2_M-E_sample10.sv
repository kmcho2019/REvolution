// Novel 8-bit 2-to-1 multiplexer implementation using case statement
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

    // Use case statement for explicit multiplexer logic
    always @(*) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = 8'b0; // default value
        endcase
    end

endmodule