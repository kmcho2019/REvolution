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
    output reg [15:0] out
);

parameter DEFAULT_VAL = 16'hFFFF; // Configurable default value

// One-hot encoded select signals with case statement clarity
wire [8:0] sel_onehot;
always @(*) begin
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
        default: sel_onehot = 9'b000000000;
    endcase
end

// Implement 16 parallel 1-bit 9-to-1 muxes with shared decoding
genvar bit_idx;
generate
    for (bit_idx = 0; bit_idx < 16; bit_idx = bit_idx + 1) begin: bit_mux
        wire mux_bit;
        assign mux_bit = 
            (sel_onehot[0] & a[bit_idx]) |
            (sel_onehot[1] & b[bit_idx]) |
            (sel_onehot[2] & c[bit_idx]) |
            (sel_onehot[3] & d[bit_idx]) |
            (sel_onehot[4] & e[bit_idx]) |
            (sel_onehot[5] & f[bit_idx]) |
            (sel_onehot[6] & g[bit_idx]) |
            (sel_onehot[7] & h[bit_idx]) |
            (sel_onehot[8] & i[bit_idx]);
        
        // Combine with default handling
        assign out[bit_idx] = (|sel_onehot) ? mux_bit : DEFAULT_VAL[bit_idx];
    end
endgenerate

endmodule