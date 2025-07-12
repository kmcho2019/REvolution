module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    wire [1023:0] shifted_in;

    // Barrel shifter to shift the input vector
    assign shifted_in = (sel[7:4] == 4'd0)  ? in                          :
                       (sel[7:4] == 4'd1)  ? {in[1019:0], 4'd0}             :
                       (sel[7:4] == 4'd2)  ? {in[1015:0], 8'd0}             :
                       (sel[7:4] == 4'd3)  ? {in[1011:0], 12'd0}            :
                       (sel[7:4] == 4'd4)  ? {in[1007:0], 16'd0}            :
                       (sel[7:4] == 4'd5)  ? {in[1003:0], 20'd0}            :
                       (sel[7:4] == 4'd6)  ? {in[999:0],  24'd0}            :
                       (sel[7:4] == 4'd7)  ? {in[995:0],  28'd0}            :
                       (sel[7:4] == 4'd8)  ? {in[991:0],  32'd0}            :
                       (sel[7:4] == 4'd9)  ? {in[987:0],  36'd0}            :
                       (sel[7:4] == 4'd10) ? {in[983:0],  40'd0}            :
                       (sel[7:4] == 4'd11) ? {in[979:0],  44'd0}            :
                       (sel[7:4] == 4'd12) ? {in[975:0],  48'd0}            :
                       (sel[7:4] == 4'd13) ? {in[971:0],  52'd0}            :
                       (sel[7:4] == 4'd14) ? {in[967:0],  56'd0}            :
                       (sel[7:4] == 4'd15) ? {in[963:0],  60'd0}            : 1024'd0;

    // Decoder to select the correct 4-bit output
    assign out = shifted_in[3 + (sel[3:0] * 4) +: 4];

endmodule