module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input              sel,
    output [WIDTH-1:0] out
);

    // Simple ternary mux - optimal for timing and area
    assign out = sel ? b : a;

    /* Power optimization suggestion (uncomment if needed):
    // Only update output when inputs change or sel toggles
    // reg [WIDTH-1:0] out_reg;
    // always @(a or b or sel) out_reg <= sel ? b : a;
    // assign out = out_reg;
    */

endmodule