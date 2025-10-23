/*
 * TopModule - NOR Gate with Procedural Assignment
 * 
 * Functionality:
 * Performs bitwise NOR operation between inputs a and b
 * Implemented using procedural assignment in always block
 * 
 * Truth Table (per bit):
 * a b | out
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 */
module TopModule #(
    parameter WIDTH = 1
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output reg [WIDTH-1:0] out
);
    always @(*) begin
        out = ~(a | b);  // NOR operation using procedural assignment
    end
endmodule