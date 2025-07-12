module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    wire [63:0] group_out;

    // First level of multiplexers: select one of the 16 groups of 64 bits
    assign group_out = (sel[7:4] == 4'd0)  ? in[63:0]  :
                       (sel[7:4] == 4'd1)  ? in[127:64] :
                       (sel[7:4] == 4'd2)  ? in[191:128] :
                       (sel[7:4] == 4'd3)  ? in[255:192] :
                       (sel[7:4] == 4'd4)  ? in[319:256] :
                       (sel[7:4] == 4'd5)  ? in[383:320] :
                       (sel[7:4] == 4'd6)  ? in[447:384] :
                       (sel[7:4] == 4'd7)  ? in[511:448] :
                       (sel[7:4] == 4'd8)  ? in[575:512] :
                       (sel[7:4] == 4'd9)  ? in[639:576] :
                       (sel[7:4] == 4'd10) ? in[703:640] :
                       (sel[7:4] == 4'd11) ? in[767:704] :
                       (sel[7:4] == 4'd12) ? in[831:768] :
                       (sel[7:4] == 4'd13) ? in[895:832] :
                       (sel[7:4] == 4'd14) ? in[959:896] :
                       (sel[7:4] == 4'd15) ? in[1023:960] : 64'd0;

    // Second level of multiplexers: select one of the 16 groups of 4 bits
    assign out = (sel[3:0] == 4'd0)  ? group_out[3:0]  :
                 (sel[3:0] == 4'd1)  ? group_out[7:4]  :
                 (sel[3:0] == 4'd2)  ? group_out[11:8] :
                 (sel[3:0] == 4'd3)  ? group_out[15:12] :
                 (sel[3:0] == 4'd4)  ? group_out[19:16] :
                 (sel[3:0] == 4'd5)  ? group_out[23:20] :
                 (sel[3:0] == 4'd6)  ? group_out[27:24] :
                 (sel[3:0] == 4'd7)  ? group_out[31:28] :
                 (sel[3:0] == 4'd8)  ? group_out[35:32] :
                 (sel[3:0] == 4'd9)  ? group_out[39:36] :
                 (sel[3:0] == 4'd10) ? group_out[43:40] :
                 (sel[3:0] == 4'd11) ? group_out[47:44] :
                 (sel[3:0] == 4'd12) ? group_out[51:48] :
                 (sel[3:0] == 4'd13) ? group_out[55:52] :
                 (sel[3:0] == 4'd14) ? group_out[59:56] :
                 (sel[3:0] == 4'd15) ? group_out[63:60] : 4'd0;

endmodule