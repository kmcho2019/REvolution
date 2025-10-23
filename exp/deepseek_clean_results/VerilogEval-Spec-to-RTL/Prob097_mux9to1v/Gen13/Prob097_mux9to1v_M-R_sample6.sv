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

// One-hot selection vector using continuous assignments
wire [8:0] sel_onehot = 
    (sel == 4'd0) ? 9'b000000001 :
    (sel == 4'd1) ? 9'b000000010 :
    (sel == 4'd2) ? 9'b000000100 :
    (sel == 4'd3) ? 9'b000001000 :
    (sel == 4'd4) ? 9'b000010000 :
    (sel == 4'd5) ? 9'b000100000 :
    (sel == 4'd6) ? 9'b001000000 :
    (sel == 4'd7) ? 9'b010000000 :
    (sel == 4'd8) ? 9'b100000000 :
                    9'b000000000;  // Default for sel >=9

// Generate each output bit in parallel
genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin: bit_loop
        assign out[bit_idx] = 
            (a[bit_idx] & sel_onehot[0]) |
            (b[bit_idx] & sel_onehot[1]) |
            (c[bit_idx] & sel_onehot[2]) |
            (d[bit_idx] & sel_onehot[3]) |
            (e[bit_idx] & sel_onehot[4]) |
            (f[bit_idx] & sel_onehot[5]) |
            (g[bit_idx] & sel_onehot[6]) |
            (h[bit_idx] & sel_onehot[7]) |
            (i[bit_idx] & sel_onehot[8]) |
            ~|sel_onehot;  // OR with 1 when no selection (sel >=9)
    end
endgenerate

endmodule