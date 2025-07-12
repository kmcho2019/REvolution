module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);

    wire bit0_sel, bit1_sel, bit2_sel, bit3_sel;

    // Generate mutually exclusive priority signals
    assign bit0_sel = in[0];
    assign bit1_sel = in[1] & ~in[0];
    assign bit2_sel = in[2] & ~in[1] & ~in[0];
    assign bit3_sel = in[3] & ~in[2] & ~in[1] & ~in[0];

    always @(*) begin
        casez (in)
            4'b???1: pos = 2'd0; // in[0] == 1
            4'b??10: pos = 2'd1; // in[1] == 1 & in[0] == 0
            4'b?100: pos = 2'd2; // in[2] == 1 & in[1:0] == 0
            4'b1000: pos = 2'd3; // in[3] == 1 & in[2:0] == 0
            default: pos = 2'd0; // no bits set
        endcase
    end

endmodule