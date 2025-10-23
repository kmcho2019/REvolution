module TopModule(in, out);
    input [254:0] in;
    output [7:0] out;

    // Define a function to count the number of '1's in an 8-bit vector
    function [7:0] popcount8(input [7:0] in);
        integer i;
        reg [7:0] count;
        count = 0;
        for (i = 0; i < 8; i = i + 1) begin
            count = count + in[i];
        end
        popcount8 = count;
    endfunction

    // Define a function to count the number of '1's in a 255-bit vector
    reg [7:0] count;

    // Calculate the population count for each 8-bit chunk
    reg [7:0] chunk_counts [31:0];
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            if (i == 31) begin
                assign chunk_counts[i] = popcount8({7'b0, in[7:0]});
            end else begin
                assign chunk_counts[i] = popcount8(in[(i*8 + 7):(i*8)]);
            end
        end
    endgenerate

    // Use an adder tree to sum up the counts from each chunk
    reg [7:0] sum0, sum1, sum2, sum3, sum4;
    assign sum0 = chunk_counts[0] + chunk_counts[1];
    assign sum1 = chunk_counts[2] + chunk_counts[3];
    assign sum2 = chunk_counts[4] + chunk_counts[5];
    assign sum3 = chunk_counts[6] + chunk_counts[7];
    assign sum4 = chunk_counts[8] + chunk_counts[9];
    reg [7:0] sum5, sum6, sum7;
    assign sum5 = sum0 + sum1;
    assign sum6 = sum2 + sum3;
    assign sum7 = sum4 + chunk_counts[10];
    reg [7:0] sum8, sum9, sum10, sum11;
    assign sum8 = sum5 + sum6;
    assign sum9 = sum7 + chunk_counts[11];
    assign sum10 = chunk_counts[12] + chunk_counts[13];
    assign sum11 = chunk_counts[14] + chunk_counts[15];
    reg [7:0] sum12, sum13;
    assign sum12 = sum8 + sum9;
    assign sum13 = sum10 + sum11;
    reg [7:0] sum14, sum15;
    assign sum14 = sum12 + sum13;
    assign sum15 = chunk_counts[16] + chunk_counts[17];
    reg [7:0] sum16, sum17;
    assign sum16 = sum14 + sum15;
    assign sum17 = chunk_counts[18] + chunk_counts[19];
    reg [7:0] sum18, sum19;
    assign sum18 = sum16 + sum17;
    assign sum19 = chunk_counts[20] + chunk_counts[21];
    reg [7:0] sum20, sum21;
    assign sum20 = sum18 + sum19;
    assign sum21 = chunk_counts[22] + chunk_counts[23];
    reg [7:0] sum22, sum23;
    assign sum22 = sum20 + sum21;
    assign sum23 = chunk_counts[24] + chunk_counts[25];
    reg [7:0] sum24, sum25;
    assign sum24 = sum22 + sum23;
    assign sum25 = chunk_counts[26] + chunk_counts[27];
    reg [7:0] sum26, sum27;
    assign sum26 = sum24 + sum25;
    assign sum27 = chunk_counts[28] + chunk_counts[29];
    reg [7:0] sum28, sum29;
    assign sum28 = sum26 + sum27;
    assign sum29 = chunk_counts[30] + chunk_counts[31];
    assign out = sum28 + sum29;
endmodule