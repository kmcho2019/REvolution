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

// Early detection of valid selection for power optimization
wire valid_sel = (sel < 9);

// Gated one-hot selection vector (only active when valid_sel is true)
reg [8:0] sel_onehot;

always @(*) begin
    if (valid_sel) begin
        case (sel)
            4'd0: sel_onehot = 9'b000000001;
            4'd1: sel_onehot = 9'b000000010;
            4'd2: sel_onehot = 9'b000000100;
            4'd3: sel_onehot = 9'b000001000;
            4'd4: sel_onehot = 9'b000010000;
            4'd5: sel_onehot = 9'b000100000;
            4'd6: sel_onehot = 9'b001000000;
            4'd7: sel_onehot = 9'b010000000;
            4'd8: sel_onehot = 9'b100000000;
            default: sel_onehot = 9'b000000000; // Redundant but safe
        endcase
    end else begin
        sel_onehot = 9'b000000000; // Power-optimized for invalid cases
    end
end

// Generate output bits in parallel
genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin: bit_loop
        // AND each input bit with its selection (only active when valid_sel)
        wire a_bit = a[bit_idx] & sel_onehot[0];
        wire b_bit = b[bit_idx] & sel_onehot[1];
        wire c_bit = c[bit_idx] & sel_onehot[2];
        wire d_bit = d[bit_idx] & sel_onehot[3];
        wire e_bit = e[bit_idx] & sel_onehot[4];
        wire f_bit = f[bit_idx] & sel_onehot[5];
        wire g_bit = g[bit_idx] & sel_onehot[6];
        wire h_bit = h[bit_idx] & sel_onehot[7];
        wire i_bit = i[bit_idx] & sel_onehot[8];
        
        // OR all selected bits together
        wire selected_bit = a_bit | b_bit | c_bit | d_bit | e_bit | 
                          f_bit | g_bit | h_bit | i_bit;
        
        // Output is selected bit or '1' if selection is invalid
        assign out[bit_idx] = valid_sel ? selected_bit : 1'b1;
    end
endgenerate

/* Implementation Notes:
   - Combines best aspects of both examples:
     1. One-hot encoding with parallel bit processing from Example 1
     2. Early valid_sel detection from Example 2
     3. Gated one-hot decoder for power optimization
     4. Clean output generation with clear default handling
   - Optimized for timing (parallel bit processing)
   - Optimized for power (gated decoder and early valid_sel)
   - Maintains good area characteristics
*/

endmodule