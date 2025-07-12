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

// Priority encoded selection
wire [8:0] sel_onehot = (sel < 9) ? (9'b1 << sel) : 9'b0;

// Bitwise selection for each output bit
genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin: bit_select
        // Collect all input bits at this position
        wire [8:0] input_bits = {
            i[bit_idx], h[bit_idx], g[bit_idx],
            f[bit_idx], e[bit_idx], d[bit_idx],
            c[bit_idx], b[bit_idx], a[bit_idx]
        };
        
        // Priority selection
        assign out[bit_idx] = |(input_bits & sel_onehot) ? 
                             |(input_bits & sel_onehot) : 1'b1;
    end
endgenerate

/* Implementation Notes:
   - Each output bit is selected independently in parallel
   - Priority encoding naturally handles the default case
   - No sequential logic ensures maximum clock speed
   - Structure is highly scalable for more inputs/bits
   - Power efficient due to bitwise gating
*/

endmodule