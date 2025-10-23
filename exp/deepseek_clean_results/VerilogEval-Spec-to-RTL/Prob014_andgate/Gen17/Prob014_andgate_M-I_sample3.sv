/*
 * TopModule: 2-input AND gate
 * Optimal implementation using direct AND operation
 * for best performance, power, and area characteristics
 */
module TopModule(
    input  wire a,    // First input
    input  wire b,    // Second input
    output wire out   // AND result (a & b)
);
    assign out = a & b;
endmodule