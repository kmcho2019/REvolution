module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the offset within the 64-bit group based on the lower 4 bits of sel
    wire [5:0] offset = sel[3:0] * 4;

    // Select the 64-bit group based on the upper 4 bits of sel
    wire [63:0] group_out;
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

    // Select the 4-bit output from the 64-bit group_out
    assign out = group_out[offset + 3:offset];

endmodule