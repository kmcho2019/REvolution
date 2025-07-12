/*
 * 2-to-1 Multiplexer
 * Selects between inputs a and b based on sel:
 *   sel=0 -> out=a
 *   sel=1 -> out=b
 */
module TopModule (
    input  wire a,    // Input A
    input  wire b,    // Input B
    input  wire sel,  // Select signal
    output wire out   // Output
);
    // Core multiplexer logic
    assign out = sel ? b : a;
endmodule