module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);

    // Shared inverted signals to reduce redundant logic and toggling
    wire n0 = ~in[0];
    wire n1 = ~in[1];
    wire n2 = ~in[2];

    // Priority signals: only one will be high, representing the first high bit
    wire bit0_sel = in[0];
    wire bit1_sel = in[1] & n0;
    wire bit2_sel = in[2] & n1 & n0;
    wire bit3_sel = in[3] & n2 & n1 & n0;

    // Use a priority case to synthesize an efficient priority encoder
    always @* begin
        pos = 2'd0;
        priority case (1'b1)
            bit0_sel: pos = 2'd0;
            bit1_sel: pos = 2'd1;
            bit2_sel: pos = 2'd2;
            bit3_sel: pos = 2'd3;
            default:  pos = 2'd0;
        endcase
    end

endmodule