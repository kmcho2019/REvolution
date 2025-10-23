module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

// Hierarchical 3:1 mux implementation for each bit
genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin: bit_loop
        // First level muxes (3:1)
        wire [15:0] mux1_out = sel[1:0] == 2'b00 ? a[bit_idx] :
                              sel[1:0] == 2'b01 ? b[bit_idx] :
                              sel[1:0] == 2'b10 ? c[bit_idx] : 1'b0;
        
        wire [15:0] mux2_out = sel[1:0] == 2'b00 ? d[bit_idx] :
                              sel[1:0] == 2'b01 ? e[bit_idx] :
                              sel[1:0] == 2'b10 ? f[bit_idx] : 1'b0;
        
        wire [15:0] mux3_out = sel[1:0] == 2'b00 ? g[bit_idx] :
                              sel[1:0] == 2'b01 ? h[bit_idx] :
                              sel[1:0] == 2'b10 ? i[bit_idx] : 1'b0;

        // Second level mux (3:1)
        wire [15:0] mux4_out = sel[3:2] == 2'b00 ? mux1_out :
                              sel[3:2] == 2'b01 ? mux2_out :
                              sel[3:2] == 2'b10 ? mux3_out : 1'b1;

        // Output is selected value or '1' if invalid selection
        assign out[bit_idx] = sel[3] ? 1'b1 : mux4_out;
    end
endgenerate

endmodule