module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Split selector into byte and bit components
    wire [3:0] byte_sel = sel[7:4];
    wire [3:0] bit_sel = sel[3:0];
    
    // First level: Select one of 16 bytes (16-bit chunks)
    wire [15:0] selected_byte;
    assign selected_byte = 
        (byte_sel == 4'd0)  ? in[15:0]   :
        (byte_sel == 4'd1)  ? in[31:16]  :
        (byte_sel == 4'd2)  ? in[47:32]  :
        (byte_sel == 4'd3)  ? in[63:48]  :
        (byte_sel == 4'd4)  ? in[79:64]  :
        (byte_sel == 4'd5)  ? in[95:80]  :
        (byte_sel == 4'd6)  ? in[111:96] :
        (byte_sel == 4'd7)  ? in[127:112] :
        (byte_sel == 4'd8)  ? in[143:128] :
        (byte_sel == 4'd9)  ? in[159:144] :
        (byte_sel == 4'd10) ? in[175:160] :
        (byte_sel == 4'd11) ? in[191:176] :
        (byte_sel == 4'd12) ? in[207:192] :
        (byte_sel == 4'd13) ? in[223:208] :
        (byte_sel == 4'd14) ? in[239:224] :
                               in[255:240];
    
    // Second level: Select one bit from the selected byte
    assign out = 
        (bit_sel == 4'd0)  ? selected_byte[0]  :
        (bit_sel == 4'd1)  ? selected_byte[1]  :
        (bit_sel == 4'd2)  ? selected_byte[2]  :
        (bit_sel == 4'd3)  ? selected_byte[3]  :
        (bit_sel == 4'd4)  ? selected_byte[4]  :
        (bit_sel == 4'd5)  ? selected_byte[5]  :
        (bit_sel == 4'd6)  ? selected_byte[6]  :
        (bit_sel == 4'd7)  ? selected_byte[7]  :
        (bit_sel == 4'd8)  ? selected_byte[8]  :
        (bit_sel == 4'd9)  ? selected_byte[9]  :
        (bit_sel == 4'd10) ? selected_byte[10] :
        (bit_sel == 4'd11) ? selected_byte[11] :
        (bit_sel == 4'd12) ? selected_byte[12] :
        (bit_sel == 4'd13) ? selected_byte[13] :
        (bit_sel == 4'd14) ? selected_byte[14] :
                              selected_byte[15];

endmodule