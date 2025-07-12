module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);
    wire bit0_sel, bit1_sel, bit2_sel, bit3_sel;

    // Generate one-hot selection signals with priority
    assign bit0_sel = in[0];
    assign bit1_sel = in[1] & ~in[0];
    assign bit2_sel = in[2] & ~in[1] & ~in[0];
    assign bit3_sel = in[3] & ~in[2] & ~in[1] & ~in[0];

    always @(*) begin
        // Default output if no bit set
        pos = 2'd0;

        // Priority encoding with case for clarity and synthesis efficiency
        case (1'b1)
            bit0_sel: pos = 2'd0;
            bit1_sel: pos = 2'd1;
            bit2_sel: pos = 2'd2;
            bit3_sel: pos = 2'd3;
            default:  pos = 2'd0; // no bits set
        endcase
    end

endmodule