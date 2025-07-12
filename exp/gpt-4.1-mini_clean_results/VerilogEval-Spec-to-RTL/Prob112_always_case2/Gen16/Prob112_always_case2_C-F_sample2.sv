module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);
    // Generate explicit priority one-hot signals with masking for power efficiency:
    wire bit0_sel = in[0];
    wire bit1_sel = in[1] & ~in[0];
    wire bit2_sel = in[2] & ~in[1] & ~in[0];
    wire bit3_sel = in[3] & ~in[2] & ~in[1] & ~in[0];

    // Use a casez statement on these priority signals to encode the output position:
    always @(*) begin
        casez ({bit3_sel, bit2_sel, bit1_sel, bit0_sel})
            4'b0001: pos = 2'd0;
            4'b0010: pos = 2'd1;
            4'b0100: pos = 2'd2;
            4'b1000: pos = 2'd3;
            default: pos = 2'd0; // No bits set
        endcase
    end
endmodule