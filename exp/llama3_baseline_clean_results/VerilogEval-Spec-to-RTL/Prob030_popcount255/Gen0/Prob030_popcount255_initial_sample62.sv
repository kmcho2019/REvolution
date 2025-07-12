module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    wire [7:0] count_bytes [31:0];

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            assign count_bytes[i] = {8{1'b0}} + 
                                   in[8*i+7:8*i] + 
                                   in[8*i+6:8*i+1] + 
                                   in[8*i+5:8*i+2] + 
                                   in[8*i+4:8*i+3];
        end
    endgenerate

    wire [7:0] count_bytes_sum [3:0];

    assign count_bytes_sum[0] = count_bytes[0] + count_bytes[1] + count_bytes[2] + count_bytes[3];
    assign count_bytes_sum[1] = count_bytes[4] + count_bytes[5] + count_bytes[6] + count_bytes[7];
    assign count_bytes_sum[2] = count_bytes[8] + count_bytes[9] + count_bytes[10] + count_bytes[11];
    assign count_bytes_sum[3] = count_bytes[12] + count_bytes[13] + count_bytes[14] + count_bytes[15];

    wire [7:0] count_bytes_sum2 [1:0];

    assign count_bytes_sum2[0] = count_bytes_sum[0] + count_bytes_sum[1];
    assign count_bytes_sum2[1] = count_bytes_sum[2] + count_bytes_sum[3];

    wire [7:0] count_bytes_sum3 [0:0];

    assign count_bytes_sum3[0] = count_bytes_sum2[0] + count_bytes_sum2[1];

    assign out = count_bytes_sum3[0];

endmodule