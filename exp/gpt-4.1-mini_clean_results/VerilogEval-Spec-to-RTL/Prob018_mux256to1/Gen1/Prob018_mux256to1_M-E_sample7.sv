module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);

    wire [15:0] stage1_out;

    // First stage: 16 groups of 16 bits
    reg [15:0] group_selected;
    always @(*) begin
        case(sel[7:4])
            4'd0:  group_selected = in[15:0];
            4'd1:  group_selected = in[31:16];
            4'd2:  group_selected = in[47:32];
            4'd3:  group_selected = in[63:48];
            4'd4:  group_selected = in[79:64];
            4'd5:  group_selected = in[95:80];
            4'd6:  group_selected = in[111:96];
            4'd7:  group_selected = in[127:112];
            4'd8:  group_selected = in[143:128];
            4'd9:  group_selected = in[159:144];
            4'd10: group_selected = in[175:160];
            4'd11: group_selected = in[191:176];
            4'd12: group_selected = in[207:192];
            4'd13: group_selected = in[223:208];
            4'd14: group_selected = in[239:224];
            4'd15: group_selected = in[255:240];
            default: group_selected = 16'd0;
        endcase
    end

    // Second stage: select bit from the 16-bit group
    assign out = group_selected[sel[3:0]];

endmodule