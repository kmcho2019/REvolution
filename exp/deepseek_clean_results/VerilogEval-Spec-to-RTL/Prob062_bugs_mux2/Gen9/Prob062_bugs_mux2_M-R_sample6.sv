module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Implement 8-bit 2-to-1 mux using AND-OR gates for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_bit
            wire not_sel;
            wire and_a, and_b;
            
            assign not_sel = ~sel;
            assign and_a = not_sel & a[i];
            assign and_b = sel & b[i];
            assign out[i] = and_a | and_b;
        end
    endgenerate

endmodule