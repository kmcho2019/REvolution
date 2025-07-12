module TopModule(
    input   [255:0] in,
    output  [7:0] out
);

    // Divide the input into 32 chunks of 8 bits
    wire [7:0] count [31:0];
    
    // Calculate population count for each chunk
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            population_count #(.WIDTH(8)) u_population_count(
               .in(in[(i*8)+:8]),
               .out(count[i])
            );
        end
    endgenerate
    
    // Sum up the counts using a tree-like structure of adders
    wire [7:0] sum_0, sum_1, sum_2, sum_3, sum_4;
    assign sum_0 = count[0] + count[1];
    assign sum_1 = count[2] + count[3];
    assign sum_2 = count[4] + count[5];
    assign sum_3 = count[6] + count[7];
    assign sum_4 = count[8] + count[9];
    
    wire [7:0] sum_5, sum_6, sum_7, sum_8, sum_9;
    assign sum_5 = count[10] + count[11];
    assign sum_6 = count[12] + count[13];
    assign sum_7 = count[14] + count[15];
    assign sum_8 = count[16] + count[17];
    assign sum_9 = count[18] + count[19];
    
    wire [7:0] sum_10, sum_11, sum_12, sum_13, sum_14;
    assign sum_10 = count[20] + count[21];
    assign sum_11 = count[22] + count[23];
    assign sum_12 = count[24] + count[25];
    assign sum_13 = count[26] + count[27];
    assign sum_14 = count[28] + count[29];
    
    wire [7:0] sum_15;
    assign sum_15 = count[30] + count[31];
    
    wire [7:0] sum_16, sum_17, sum_18, sum_19, sum_20;
    assign sum_16 = sum_0 + sum_1;
    assign sum_17 = sum_2 + sum_3;
    assign sum_18 = sum_4 + sum_5;
    assign sum_19 = sum_6 + sum_7;
    assign sum_20 = sum_8 + sum_9;
    
    wire [7:0] sum_21, sum_22, sum_23;
    assign sum_21 = sum_10 + sum_11;
    assign sum_22 = sum_12 + sum_13;
    assign sum_23 = sum_14 + sum_15;
    
    wire [7:0] sum_24, sum_25;
    assign sum_24 = sum_16 + sum_17;
    assign sum_25 = sum_18 + sum_19;
    
    wire [7:0] sum_26;
    assign sum_26 = sum_20 + sum_21;
    
    wire [7:0] sum_27;
    assign sum_27 = sum_22 + sum_23;
    
    wire [7:0] sum_28;
    assign sum_28 = sum_24 + sum_25;
    
    wire [7:0] sum_29;
    assign sum_29 = sum_26 + sum_27;
    
    wire [7:0] sum_30;
    assign sum_30 = sum_28 + sum_29;
    
    assign out = sum_30;

endmodule

module population_count #(
    parameter WIDTH = 8
)(
    input   [WIDTH-1:0] in,
    output  [7:0] out
);

    assign out = {8{1'b0}};
    always @(*) begin
        for (int i = 0; i < WIDTH; i = i + 1) begin
            if (in[i] == 1'b1) begin
                out = out + 8'd1;
            end
        end
    end

endmodule