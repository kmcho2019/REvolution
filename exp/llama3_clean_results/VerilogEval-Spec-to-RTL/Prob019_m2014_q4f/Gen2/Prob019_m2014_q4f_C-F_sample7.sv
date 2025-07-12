/**
 * Module: TopModule
 * 
 * Description: This module implements a simple logical circuit where two inputs (in1 and in2) 
 *              are connected to an AND gate, but the in2 input has a bubble (inversion).
 *              The output of the AND gate is connected to 'out'.
 * 
 * Parameters:
 * - in1: First input to the AND gate.
 * - in2: Second input to the AND gate, which is inverted before the AND operation.
 * - out: Output of the AND gate.
 */
module TopModule(
    input  in1,
    input  in2,
    output out
);

// Directly assign the result of the AND operation between in1 and the inverted in2 to out.
assign out = in1 & ~in2;

endmodule