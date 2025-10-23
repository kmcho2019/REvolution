/*
 * TopModule - Structural CMOS NOR Gate Implementation
 * 
 * Functionality:
 * Implements a NOR gate using transistor-level modeling
 * out = ~(a | b)
 * 
 * Structure:
 * - Pull-up network: Two PMOS in series
 * - Pull-down network: Two NMOS in parallel
 * - Properly models power (VDD) and ground connections
 * 
 * Advantages:
 * - More accurate physical representation
 * - Better synthesis control
 * - Foundation for custom transistor sizing
 * - Clear demonstration of CMOS logic principles
 */
module TopModule (
    input  a,     // First input
    input  b,     // Second input
    output out    // NOR output
);

    // Internal nodes
    wire out_bar;
    supply1 VDD;  // Power supply
    supply0 GND;  // Ground

    // Pull-up network (PMOS transistors in series)
    pmos p1(out_bar, VDD, a);
    pmos p2(out_bar, VDD, b);

    // Pull-down network (NMOS transistors in parallel)
    nmos n1(out_bar, GND, a);
    nmos n2(out_bar, GND, b);

    // Output inverter to get correct polarity
    pmos p3(out, VDD, out_bar);
    nmos n3(out, GND, out_bar);

    /*
     * Truth Table:
     * a b | out_bar | out
     * ------------------
     * 0 0 |    1    |  0
     * 0 1 |    0    |  1
     * 1 0 |    0    |  1
     * 1 1 |    0    |  1
     */
endmodule