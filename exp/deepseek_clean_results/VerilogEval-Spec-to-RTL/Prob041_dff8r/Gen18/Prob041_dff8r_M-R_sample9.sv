/**
 * TopModule - 8-bit Register with Synchronous Reset (Structural Implementation)
 * 
 * Features:
 * - Parameterized width (default 8 bits)
 * - Positive edge-triggered D flip-flops using primitives
 * - Synchronous active-high reset implemented with combinational logic
 * - Clear structural implementation
 */

// Primitive D flip-flop definition (simplified for this example)
primitive udp_dff(q, clk, d);
    output q;
    input clk, d;
    reg q;

    table
        // clk  d  : q : q+
        (01) 0 : ? : 0;  // Rising clock, d=0
        (01) 1 : ? : 1;  // Rising clock, d=1
        (0?) ? : ? : -;  // Non-rising clock - hold
        ? (??) : ? : -;  // No clock change - hold
    endtable
endprimitive

module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q
);

    // Reset logic - when reset is high, feed 0 to DFF inputs
    wire [WIDTH-1:0] d_ff_input;
    assign d_ff_input = reset ? {WIDTH{1'b0}} : d;

    // Instantiate D flip-flops for each bit
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : dff_array
            udp_dff dff_inst (
                .q(q[i]),
                .clk(clk),
                .d(d_ff_input[i])
            );
        end
    endgenerate

endmodule