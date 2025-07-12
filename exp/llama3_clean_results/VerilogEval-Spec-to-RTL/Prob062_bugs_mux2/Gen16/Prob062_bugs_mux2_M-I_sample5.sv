// Improved 8-bit 2-to-1 multiplexer implementation
module TopModule (
    // Select line input
    input        sel,
    // 8-bit input a
    input  [7:0] a,
    // 8-bit input b
    input  [7:0] b,
    // 8-bit output selected based on sel
    output reg [7:0] out
);

    // Use ternary operator for efficient multiplexer logic
    always @(*) begin
        out = (sel == 1'b0) ? a : b;
    end

endmodule