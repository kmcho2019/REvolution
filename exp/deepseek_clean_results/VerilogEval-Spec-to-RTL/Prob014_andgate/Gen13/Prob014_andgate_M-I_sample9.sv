/* Simple 2-input AND gate implementation
 * Inputs: a, b
 * Output: out = a & b
 */
module TopModule(
    input wire a,
    input wire b,
    output wire out
);
    assign out = a & b;
endmodule