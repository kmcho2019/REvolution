module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Implement 8 individual 1-bit 2-to-1 muxes
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_array
            // AND gates for selection
            wire a_selected, b_selected;
            assign a_selected = ~sel & a[i];
            assign b_selected = sel & b[i];
            
            // OR gate for final output
            assign out[i] = a_selected | b_selected;
        end
    endgenerate

endmodule