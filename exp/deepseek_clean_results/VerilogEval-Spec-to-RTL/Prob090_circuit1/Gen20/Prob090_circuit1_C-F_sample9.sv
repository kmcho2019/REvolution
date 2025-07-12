module TopModule #(
    parameter USE_MUX = 0  // 0 for AND, 1 for mux implementation
) (
    input  a,
    input  b,
    output q
);
    generate
        if (USE_MUX) begin
            // Mux-based implementation (Example 1)
            assign q = b ? a : 1'b0;
        end else begin
            // Direct AND implementation (Example 2)
            assign q = a & b;
        end
    endgenerate
endmodule