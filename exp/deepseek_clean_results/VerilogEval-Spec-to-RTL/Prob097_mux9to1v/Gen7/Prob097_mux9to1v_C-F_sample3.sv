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

wire valid_sel = (sel < 9);
wire [15:0] mux_out;

genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin: bit_mux
        // Binary-encoded case statement for each bit
        assign mux_out[bit_idx] = 
            (sel == 0) ? a[bit_idx] :
            (sel == 1) ? b[bit_idx] :
            (sel == 2) ? c[bit_idx] :
            (sel == 3) ? d[bit_idx] :
            (sel == 4) ? e[bit_idx] :
            (sel == 5) ? f[bit_idx] :
            (sel == 6) ? g[bit_idx] :
            (sel == 7) ? h[bit_idx] :
            (sel == 8) ? i[bit_idx] :
            1'b1; // Default case (optimized away when valid_sel=1)
    end
endgenerate

// Final output with efficient default handling
assign out = valid_sel ? mux_out : {16{1'b1}};

endmodule