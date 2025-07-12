module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Register to hold the selected group (power optimization)
    reg [15:0] selected_group;

    // Group selection (upper 4 bits)
    always @(*) begin
        case (sel[7:4])
            4'd0:  selected_group = in[15:0];
            4'd1:  selected_group = in[31:16];
            4'd2:  selected_group = in[47:32];
            4'd3:  selected_group = in[63:48];
            4'd4:  selected_group = in[79:64];
            4'd5:  selected_group = in[95:80];
            4'd6:  selected_group = in[111:96];
            4'd7:  selected_group = in[127:112];
            4'd8:  selected_group = in[143:128];
            4'd9:  selected_group = in[159:144];
            4'd10: selected_group = in[175:160];
            4'd11: selected_group = in[191:176];
            4'd12: selected_group = in[207:192];
            4'd13: selected_group = in[223:208];
            4'd14: selected_group = in[239:224];
            4'd15: selected_group = in[255:240];
        endcase
    end

    // Bit selection (lower 4 bits) - direct indexing for minimal logic
    assign out = selected_group[sel[3:0]];

endmodule