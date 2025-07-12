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
wire invalid_sel = (sel >= 4'd9);

// One-hot decode of selection
wire [8:0] sel_onehot;
assign sel_onehot = (invalid_sel) ? 9'd0 : 
                   (sel == 4'd0) ? 9'b000000001 :
                   (sel == 4'd1) ? 9'b000000010 :
                   (sel == 4'd2) ? 9'b000000100 :
                   (sel == 4'd3) ? 9'b000001000 :
                   (sel == 4'd4) ? 9'b000010000 :
                   (sel == 4'd5) ? 9'b000100000 :
                   (sel == 4'd6) ? 9'b001000000 :
                   (sel == 4'd7) ? 9'b010000000 :
                   9'b100000000;  // sel == 4'd8

// Bit-sliced parallel selection
genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin: bit_slice
        wire a_bit = a[bit_idx] & sel_onehot[0];
        wire b_bit = b[bit_idx] & sel_onehot[1];
        wire c_bit = c[bit_idx] & sel_onehot[2];
        wire d_bit = d[bit_idx] & sel_onehot[3];
        wire e_bit = e[bit_idx] & sel_onehot[4];
        wire f_bit = f[bit_idx] & sel_onehot[5];
        wire g_bit = g[bit_idx] & sel_onehot[6];
        wire h_bit = h[bit_idx] & sel_onehot[7];
        wire i_bit = i[bit_idx] & sel_onehot[8];
        
        // OR all selected bits
        wire selected_bit = a_bit | b_bit | c_bit | d_bit | e_bit | 
                          f_bit | g_bit | h_bit | i_bit;
        
        // Output with default handling
        assign out[bit_idx] = invalid_sel ? 1'b1 : selected_bit;
    end
endgenerate

endmodule