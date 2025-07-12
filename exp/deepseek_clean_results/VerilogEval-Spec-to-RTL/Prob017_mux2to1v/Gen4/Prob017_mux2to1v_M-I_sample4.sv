module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              sel,
    output [WIDTH-1:0] out
);

    // Optimized parameterized 2:1 mux with operand isolation potential
    // When sel is stable for multiple cycles, synthesis tools can optimize power
    // by gating the input transitions (operand isolation)
    generate
        genvar i;
        for (i = 0; i < WIDTH; i = i + 1) begin : mux_gen
            assign out[i] = sel ? b[i] : a[i];
        end
    endgenerate

    /* Alternative implementation option for technologies with wide mux primitives:
    assign out = sel ? b : a;
    */

endmodule