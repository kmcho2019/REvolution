module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    wire sel_n = ~sel;
    
    // Transmission gate implementation for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_array
            // Transmission gate for 'a' path (active when sel_n is high)
            tranif1 tg_a(out[i], a[i], sel_n);
            // Transmission gate for 'b' path (active when sel is high)
            tranif1 tg_b(out[i], b[i], sel);
        end
    endgenerate

endmodule