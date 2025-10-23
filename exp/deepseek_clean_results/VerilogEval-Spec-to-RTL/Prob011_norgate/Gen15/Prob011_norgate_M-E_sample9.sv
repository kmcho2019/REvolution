/*
 * TopModule - Transmission Gate NOR with Enhanced Features
 * 
 * Functionality:
 * Implements NOR operation using transmission gate logic with:
 * - Input buffering for signal integrity
 * - Optional output inversion
 * - Tri-state output capability
 * 
 * Truth Table (when INV_OUT=0, OE=1):
 * a b | out
 * --------
 * 0 0 | 1
 * 0 1 | 0
 * 1 0 | 0
 * 1 1 | 0
 */
module TopModule (
    input  a,       // First input
    input  b,       // Second input
    output out,     // NOR output
    input  oe = 1'b1,  // Output enable (active high)
    parameter INV_OUT = 0  // Invert output when 1
);

    // Buffered inputs
    wire a_buf, b_buf;
    buf(a_buf, a);
    buf(b_buf, b);

    // Transmission gate implementation
    wire nor_core;
    supply1 vdd;
    supply0 gnd;

    // NOR core using transmission gates
    tranif1 (nor_core, gnd, a_buf);  // Pull down when a=1
    tranif1 (nor_core, gnd, b_buf);  // Pull down when b=1
    tranif0 (nor_core, vdd, ~(a_buf | b_buf));  // Pull up when a=0 & b=0

    // Weak keeper to maintain state
    pmos (nor_core, vdd, nor_core);
    nmos (nor_core, gnd, nor_core);

    // Optional output inversion
    wire out_pre = INV_OUT ? ~nor_core : nor_core;

    // Tri-state output
    bufif1 (out, out_pre, oe);

    /*
     * Usage Examples:
     * // Basic NOR operation
     * TopModule nor1 (.a(a), .b(b), .out(out));
     * 
     * // Inverted output (becomes OR gate)
     * TopModule #(.INV_OUT(1)) or1 (.a(a), .b(b), .out(out));
     * 
     * // Tri-state application
     * TopModule nor_bus (.a(a), .b(b), .out(bus), .oe(en));
     */
endmodule