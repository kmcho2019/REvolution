module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [7:0] count_8bit [31:0];

    // Divide the 255-bit vector into 32 chunks of 8 bits (one chunk has only 7 bits)
    genvar i;
    generate
        for (i = 0; i < 31; i = i + 1) begin
            // Count the number of '1's in each 8-bit chunk
            assign count_8bit[i] = {8{1'b0}} + 
                                  in[8*i+7] + in[8*i+6] + in[8*i+5] + in[8*i+4] + 
                                  in[8*i+3] + in[8*i+2] + in[8*i+1] + in[8*i];
        end
        // Count the number of '1's in the last 7-bit chunk
        assign count_8bit[31] = {8{1'b0}} + 
                                in[254] + in[253] + in[252] + in[251] + 
                                in[250] + in[249] + in[248];
    endgenerate

    // Add up the counts from each chunk
    wire [8:0] sum;
    assign sum = {9{1'b0}};
    genvar j;
    generate
        for (j = 0; j < 32; j = j + 1) begin
            assign sum = sum + {1'b0, count_8bit[j]};
        end
    endgenerate

    // Assign the result to the output
    assign out = sum[7:0];

endmodule