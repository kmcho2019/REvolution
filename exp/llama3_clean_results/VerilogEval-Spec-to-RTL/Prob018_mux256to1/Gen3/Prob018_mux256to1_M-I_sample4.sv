module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    // Divide the 256-bit input into 16 groups of 16 bits
    wire [15:0] group0 = in[15:0];
    wire [15:0] group1 = in[31:16];
    wire [15:0] group2 = in[47:32];
    wire [15:0] group3 = in[63:48];
    wire [15:0] group4 = in[79:64];
    wire [15:0] group5 = in[95:80];
    wire [15:0] group6 = in[111:96];
    wire [15:0] group7 = in[127:112];
    wire [15:0] group8 = in[143:128];
    wire [15:0] group9 = in[159:144];
    wire [15:0] group10 = in[175:160];
    wire [15:0] group11 = in[191:176];
    wire [15:0] group12 = in[207:192];
    wire [15:0] group13 = in[223:208];
    wire [15:0] group14 = in[239:224];
    wire [15:0] group15 = in[255:240];

    // First stage: Select from each group
    wire [15:0] group_out;
    always @(*) begin
        case (sel[7:4]) // Select which group to use
            4'd0: group_out = group0;
            4'd1: group_out = group1;
            4'd2: group_out = group2;
            4'd3: group_out = group3;
            4'd4: group_out = group4;
            4'd5: group_out = group5;
            4'd6: group_out = group6;
            4'd7: group_out = group7;
            4'd8: group_out = group8;
            4'd9: group_out = group9;
            4'd10: group_out = group10;
            4'd11: group_out = group11;
            4'd12: group_out = group12;
            4'd13: group_out = group13;
            4'd14: group_out = group14;
            4'd15: group_out = group15;
            default: group_out = 16'd0; // Default, should not occur
        endcase
    end

    // Second stage: Select from the chosen group
    assign out = group_out[sel[3:0]];

endmodule