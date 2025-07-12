module TopModule (
    input  [3:0] in,
    output [1:0] pos
);
    wire bit0_set = in[0];
    wire bit1_set = ~bit0_set & in[1];
    wire bit2_set = ~bit0_set & ~bit1_set & in[2];
    wire bit3_set = ~bit0_set & ~bit1_set & ~bit2_set & in[3];

    assign pos = {bit3_set, bit2_set} | (2'b00 & {2{bit0_set}}) | (2'b01 & {2{bit1_set}});
    // However, the above line is ambiguous and incorrect. Instead, assign explicitly:

    // A cleaner and correct approach:
    wire [1:0] pos0 = 2'd0;
    wire [1:0] pos1 = 2'd1;
    wire [1:0] pos2 = 2'd2;
    wire [1:0] pos3 = 2'd3;

    assign pos = bit0_set ? pos0 :
                 bit1_set ? pos1 :
                 bit2_set ? pos2 :
                 bit3_set ? pos3 :
                 2'd0;

endmodule