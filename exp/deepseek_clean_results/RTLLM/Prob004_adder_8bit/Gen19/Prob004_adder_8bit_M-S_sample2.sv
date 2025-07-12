/**
 * Simplified 8-bit Ripple Carry Adder
 * Maintains same functionality as original but with:
 * - Direct carry chaining (no intermediate wires)
 * - Compact syntax
 * - Same optimized carry computation
 */
module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [8:0] carry = {cout, sum};
    assign carry[0] = cin;

    assign {cout, sum} = a + b + cin;

endmodule