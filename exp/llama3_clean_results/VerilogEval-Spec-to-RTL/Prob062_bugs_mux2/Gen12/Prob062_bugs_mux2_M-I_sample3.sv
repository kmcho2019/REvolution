// Improved 8-bit 2-to-1 multiplexer implementation using a case statement
module TopModule (
    // Select line input
    input        sel,
    // 8-bit input a
    input  [7:0] a,
    // 8-bit input b
    input  [7:0] b,
    // 8-bit output selected based on sel
    output reg [7:0] out // Declare out as a reg to enable assignment within the always block
);

    // Combinational always block to handle the multiplexer's logic
    always @(*) begin
        case (sel)
            1'b0: out = a; // Select input a when sel is 0
            1'b1: out = b; // Select input b when sel is 1
            default: out = 8'b0; // Default to 0 for any other value of sel
        endcase
    end

endmodule