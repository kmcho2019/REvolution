module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);
    // Explicit one-hot priority signals
    wire bit0_sel = in[0];
    wire bit1_sel = in[1] & ~in[0];
    wire bit2_sel = in[2] & ~in[1] & ~in[0];
    wire bit3_sel = in[3] & ~in[2] & ~in[1] & ~in[0];

    always @* begin
        if (bit0_sel)
            pos = 2'd0;
        else if (bit1_sel)
            pos = 2'd1;
        else if (bit2_sel)
            pos = 2'd2;
        else if (bit3_sel)
            pos = 2'd3;
        else
            pos = 2'd0; // default if no bits set
    end
endmodule