module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    wire [15:0] section_out;
    reg [3:0] section_sel;
    assign section_sel = sel[7:4];

    // First level of multiplexers: select one of the 16 sections
    always @(*) begin
        case(section_sel)
            4'd0: section_out = in[15:0];
            4'd1: section_out = in[31:16];
            4'd2: section_out = in[47:32];
            4'd3: section_out = in[63:48];
            4'd4: section_out = in[79:64];
            4'd5: section_out = in[95:80];
            4'd6: section_out = in[111:96];
            4'd7: section_out = in[127:112];
            4'd8: section_out = in[143:128];
            4'd9: section_out = in[159:144];
            4'd10: section_out = in[175:160];
            4'd11: section_out = in[191:176];
            4'd12: section_out = in[207:192];
            4'd13: section_out = in[223:208];
            4'd14: section_out = in[239:224];
            4'd15: section_out = in[255:240];
            default: section_out = 16'd0;
        endcase
    end

    // Second level of multiplexers: select the desired bit from the chosen section
    assign out = section_out[sel[3:0]];
endmodule