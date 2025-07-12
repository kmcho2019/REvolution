module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);
    wire [15:0] section_out;
    
    // First level of multiplexers: select one of the 16 sections
    assign section_out = (sel[7:4] == 4'd0) ? in[15:0] :
                         (sel[7:4] == 4'd1) ? in[31:16] :
                         (sel[7:4] == 4'd2) ? in[47:32] :
                         (sel[7:4] == 4'd3) ? in[63:48] :
                         (sel[7:4] == 4'd4) ? in[79:64] :
                         (sel[7:4] == 4'd5) ? in[95:80] :
                         (sel[7:4] == 4'd6) ? in[111:96] :
                         (sel[7:4] == 4'd7) ? in[127:112] :
                         (sel[7:4] == 4'd8) ? in[143:128] :
                         (sel[7:4] == 4'd9) ? in[159:144] :
                         (sel[7:4] == 4'd10) ? in[175:160] :
                         (sel[7:4] == 4'd11) ? in[191:176] :
                         (sel[7:4] == 4'd12) ? in[207:192] :
                         (sel[7:4] == 4'd13) ? in[223:208] :
                         (sel[7:4] == 4'd14) ? in[239:224] :
                         (sel[7:4] == 4'd15) ? in[255:240] : 16'd0;
    
    // Second level of multiplexers: select the desired bit from the chosen section
    assign out = section_out[sel[3:0]];
endmodule