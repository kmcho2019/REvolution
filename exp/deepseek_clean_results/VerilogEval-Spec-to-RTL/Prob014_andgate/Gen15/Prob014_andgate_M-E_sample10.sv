`default_nettype none

/*
 * TopModule: 2-input AND gate implemented using LUT/mux approach
 * Features:
 * - Demonstrates alternative LUT-based implementation
 * - Shows how simple logic can be mapped to mux structures
 * - Useful for educational purposes and configurable logic
 */
module TopModule(
    input  wire a,    // First input
    input  wire b,    // Second input
    output wire out   // AND operation result
);
    // Implement AND as 2-input LUT using a multiplexer
    // The concatenation {a,b} forms the 2-bit select
    assign out = ({a,b} == 2'b11) ? 1'b1 : 1'b0;
endmodule