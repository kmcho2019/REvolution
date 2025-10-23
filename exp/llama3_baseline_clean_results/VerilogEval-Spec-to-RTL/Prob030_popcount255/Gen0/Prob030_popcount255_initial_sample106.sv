module TopModule(
    input  [255:0] in,
    output [7:0] out
);

    wire [7:0] count_bytes [31:0];

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: gen_byte
            if (i < 31) begin: not_last_byte
                assign count_bytes[i] = {8{in[8*i+7:8*i]} == 8'b11111111} + 
                                     {7{in[8*i+6:8*i]} == 7'b1111111} + 
                                     {6{in[8*i+5:8*i]} == 6'b111111} + 
                                     {5{in[8*i+4:8*i]} == 5'b11111} + 
                                     {4{in[8*i+3:8*i]} == 4'b1111} + 
                                     {3{in[8*i+2:8*i]} == 3'b111} + 
                                     {2{in[8*i+1:8*i]} == 2'b11} + 
                                     {1{in[8*i]} == 1'b1};
            end else begin: last_byte
                assign count_bytes[i] = {8{in[8*i+6:8*i]} == 8'b11111111} + 
                                     {7{in[8*i+5:8*i]} == 7'b1111111} + 
                                     {6{in[8*i+4:8*i]} == 6'b111111} + 
                                     {5{in[8*i+3:8*i]} == 5'b11111} + 
                                     {4{in[8*i+2:8*i]} == 4'b1111} + 
                                     {3{in[8*i+1:8*i]} == 3'b111} + 
                                     {2{in[8*i]} == 2'b11} + 
                                     1'b0;
            end
        end
    endgenerate

    assign out = count_bytes[0] + count_bytes[1] + count_bytes[2] + count_bytes[3] +
                 count_bytes[4] + count_bytes[5] + count_bytes[6] + count_bytes[7] +
                 count_bytes[8] + count_bytes[9] + count_bytes[10] + count_bytes[11] +
                 count_bytes[12] + count_bytes[13] + count_bytes[14] + count_bytes[15] +
                 count_bytes[16] + count_bytes[17] + count_bytes[18] + count_bytes[19] +
                 count_bytes[20] + count_bytes[21] + count_bytes[22] + count_bytes[23] +
                 count_bytes[24] + count_bytes[25] + count_bytes[26] + count_bytes[27] +
                 count_bytes[28] + count_bytes[29] + count_bytes[30] + count_bytes[31];

endmodule