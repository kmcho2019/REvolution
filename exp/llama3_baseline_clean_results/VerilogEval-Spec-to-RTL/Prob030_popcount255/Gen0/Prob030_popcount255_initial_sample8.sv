module TopModule(
    input [254:0] in,
    output [7:0] out
);

    wire [7:0] count_8bit [31:0];

    // Divide the 255-bit input into 32 groups of 8 bits (except the last group which has 7 bits)
    genvar i;
    generate
        for (i = 0; i < 32; i++) begin: group_8bit
            assign count_8bit[i] = {8{1'b0}} + in[8*i +: 8];
        end
    endgenerate

    // Sum up the counts from all groups
    wire [7:0] sum;
    assign sum = {8{1'b0}};
    genvar j;
    generate
        for (j = 0; j < 32; j++) begin: sum_counts
            assign sum = sum + count_8bit[j];
        end
    endgenerate

    assign out = sum[7:0];

endmodule