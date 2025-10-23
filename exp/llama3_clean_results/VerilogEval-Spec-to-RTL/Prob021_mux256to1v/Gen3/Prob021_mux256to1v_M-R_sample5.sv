module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    wire [63:0] group_out;

    // Calculate the index of the 64-bit group
    wire [5:0] group_idx = sel[7:4] * 64;

    // First level of multiplexers: select one of the 16 groups of 64 bits
    always @(*)
    begin
        case (sel[7:4])
            4'd0: group_out = in[63:0];
            4'd1: group_out = in[127:64];
            4'd2: group_out = in[191:128];
            4'd3: group_out = in[255:192];
            4'd4: group_out = in[319:256];
            4'd5: group_out = in[383:320];
            4'd6: group_out = in[447:384];
            4'd7: group_out = in[511:448];
            4'd8: group_out = in[575:512];
            4'd9: group_out = in[639:576];
            4'd10: group_out = in[703:640];
            4'd11: group_out = in[767:704];
            4'd12: group_out = in[831:768];
            4'd13: group_out = in[895:832];
            4'd14: group_out = in[959:896];
            4'd15: group_out = in[1023:960];
            default: group_out = 64'd0;
        endcase
    end

    // Calculate the index of the 4-bit group within the selected 64-bit group
    wire [5:0] subgroup_idx = sel[3:0] * 4;

    // Second level of multiplexers: select one of the 16 groups of 4 bits
    always @(*)
    begin
        case (sel[3:0])
            4'd0: out = group_out[3:0];
            4'd1: out = group_out[7:4];
            4'd2: out = group_out[11:8];
            4'd3: out = group_out[15:12];
            4'd4: out = group_out[19:16];
            4'd5: out = group_out[23:20];
            4'd6: out = group_out[27:24];
            4'd7: out = group_out[31:28];
            4'd8: out = group_out[35:32];
            4'd9: out = group_out[39:36];
            4'd10: out = group_out[43:40];
            4'd11: out = group_out[47:44];
            4'd12: out = group_out[51:48];
            4'd13: out = group_out[55:52];
            4'd14: out = group_out[59:56];
            4'd15: out = group_out[63:60];
            default: out = 4'd0;
        endcase
    end

endmodule