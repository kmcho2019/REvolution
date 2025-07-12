module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);
    wire bit0_sel, bit1_sel, bit2_sel, bit3_sel;

    // Explicit priority signals: the first '1' bit, lowest index first
    assign bit0_sel = in[0];
    assign bit1_sel = in[1] & ~in[0];
    assign bit2_sel = in[2] & ~in[1] & ~in[0];
    assign bit3_sel = in[3] & ~in[2] & ~in[1] & ~in[0];

    // Priority case statement on the explicit priority bits for efficient encoding
    always @(*) begin
        pos = 2'd0;
        priority case (1'b1)
            bit0_sel: pos = 2'd0;
            bit1_sel: pos = 2'd1;
            bit2_sel: pos = 2'd2;
            bit3_sel: pos = 2'd3;
            default: pos = 2'd0; // no bits set
        endcase
    end
endmodule