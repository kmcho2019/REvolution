module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);
    // One-hot enables for the first set bit positions
    wire bit0_sel = in[0];
    wire bit1_sel = in[1] & ~in[0];
    wire bit2_sel = in[2] & ~in[1] & ~in[0];
    wire bit3_sel = in[3] & ~in[2] & ~in[1] & ~in[0];

    // Combine enables into a single vector for priority case
    wire [3:0] onehot = {bit3_sel, bit2_sel, bit1_sel, bit0_sel};

    always @* begin
        pos = 2'd0;
        priority case (1'b1)
            onehot[0]: pos = 2'd0;
            onehot[1]: pos = 2'd1;
            onehot[2]: pos = 2'd2;
            onehot[3]: pos = 2'd3;
            default:   pos = 2'd0;
        endcase
    end
endmodule