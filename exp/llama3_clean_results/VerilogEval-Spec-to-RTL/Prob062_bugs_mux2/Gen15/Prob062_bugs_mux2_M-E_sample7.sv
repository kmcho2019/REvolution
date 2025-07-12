// Parameterized 8-bit 2-to-1 multiplexer implementation
module TopModule #(
    parameter WIDTH = 8
)(
    // Select line input
    input        sel,
    // WIDTH-bit input a
    input  [WIDTH-1:0] a,
    // WIDTH-bit input b
    input  [WIDTH-1:0] b,
    // WIDTH-bit output selected based on sel
    output [WIDTH-1:0] out
);

    // Use a case statement to select the output based on 'sel'
    always @(*) begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = {WIDTH{1'bx}}; // Default to unknown if 'sel' is not 0 or 1
        endcase
    end

endmodule