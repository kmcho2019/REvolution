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

// Early detection of invalid selection
wire sel_valid = (sel <= 4'd8);
wire [8:0] sel_onehot = sel_valid ? 
    (9'b000000001 << sel) : 9'b000000000;

// Generate output bits in parallel
genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin: bit_loop
        // AND each input bit with its selection
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
        
        // Output is selected bit or '1' if invalid selection
        assign out[bit_idx] = sel_valid ? selected_bit : 1'b1;
    end
endgenerate

endmodule