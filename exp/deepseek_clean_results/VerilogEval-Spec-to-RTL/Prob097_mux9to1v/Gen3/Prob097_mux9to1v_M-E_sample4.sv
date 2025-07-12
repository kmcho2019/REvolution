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

// Internal signals
wire [15:0] stage1 [0:8];  // First stage outputs
wire [15:0] stage2 [0:3];  // Second stage outputs
wire [15:0] stage3 [0:1];  // Third stage outputs
wire        unused_case;    // Flag for unused cases

// Detect unused cases (sel >= 9)
assign unused_case = (sel >= 4'd9);

// First stage: 9 inputs to 5 outputs
genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin: bit_slice
        // Stage 1 muxes
        assign stage1[0][bit_idx] = sel[0] ? b[bit_idx] : a[bit_idx];
        assign stage1[1][bit_idx] = sel[0] ? d[bit_idx] : c[bit_idx];
        assign stage1[2][bit_idx] = sel[0] ? f[bit_idx] : e[bit_idx];
        assign stage1[3][bit_idx] = sel[0] ? h[bit_idx] : g[bit_idx];
        assign stage1[4][bit_idx] = i[bit_idx];  // Last input passes through
        
        // Stage 2 muxes
        assign stage2[0][bit_idx] = sel[1] ? stage1[1][bit_idx] : stage1[0][bit_idx];
        assign stage2[1][bit_idx] = sel[1] ? stage1[3][bit_idx] : stage1[2][bit_idx];
        assign stage2[2][bit_idx] = stage1[4][bit_idx];  // Pass through
        
        // Stage 3 muxes
        assign stage3[0][bit_idx] = sel[2] ? stage2[1][bit_idx] : stage2[0][bit_idx];
        assign stage3[1][bit_idx] = stage2[2][bit_idx];  // Pass through
        
        // Final output with unused case handling
        assign out[bit_idx] = unused_case ? 1'b1 : (sel[3] ? stage3[1][bit_idx] : stage3[0][bit_idx]);
    end
endgenerate

endmodule