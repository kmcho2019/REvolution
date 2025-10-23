module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    // Define a function to count the number of '1's in an 8-bit vector
    function [4:0] count_ones;
        input [7:0] in;
        begin
            count_ones = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]} +
                         {1'b0, in[4]} + {1'b0, in[5]} + {1'b0, in[6]} + {1'b0, in[7]};
        end
    endfunction

    // Define a function to count the number of '1's in a 7-bit vector
    function [3:0] count_ones_7;
        input [6:0] in;
        begin
            count_ones_7 = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]} + {1'b0, in[3]} +
                           {1'b0, in[4]} + {1'b0, in[5]} + {1'b0, in[6]};
        end
    endfunction

    // Count the number of '1's in each 8-bit chunk
    wire [4:0] count_0  = count_ones(in[7:0]);
    wire [4:0] count_1  = count_ones(in[15:8]);
    wire [4:0] count_2  = count_ones(in[23:16]);
    wire [4:0] count_3  = count_ones(in[31:24]);
    wire [4:0] count_4  = count_ones(in[39:32]);
    wire [4:0] count_5  = count_ones(in[47:40]);
    wire [4:0] count_6  = count_ones(in[55:48]);
    wire [4:0] count_7  = count_ones(in[63:56]);
    wire [4:0] count_8  = count_ones(in[71:64]);
    wire [4:0] count_9  = count_ones(in[79:72]);
    wire [4:0] count_10 = count_ones(in[87:80]);
    wire [4:0] count_11 = count_ones(in[95:88]);
    wire [4:0] count_12 = count_ones(in[103:96]);
    wire [4:0] count_13 = count_ones(in[111:104]);
    wire [4:0] count_14 = count_ones(in[119:112]);
    wire [4:0] count_15 = count_ones(in[127:120]);
    wire [4:0] count_16 = count_ones(in[135:128]);
    wire [4:0] count_17 = count_ones(in[143:136]);
    wire [4:0] count_18 = count_ones(in[151:144]);
    wire [4:0] count_19 = count_ones(in[159:152]);
    wire [4:0] count_20 = count_ones(in[167:160]);
    wire [4:0] count_21 = count_ones(in[175:168]);
    wire [4:0] count_22 = count_ones(in[183:176]);
    wire [4:0] count_23 = count_ones(in[191:184]);
    wire [4:0] count_24 = count_ones(in[199:192]);
    wire [4:0] count_25 = count_ones(in[207:200]);
    wire [4:0] count_26 = count_ones(in[215:208]);
    wire [4:0] count_27 = count_ones(in[223:216]);
    wire [4:0] count_28 = count_ones(in[231:224]);
    wire [4:0] count_29 = count_ones(in[239:232]);
    wire [4:0] count_30 = count_ones(in[247:240]);
    wire [3:0] count_31 = count_ones_7(in[254:248]);

    // Sum up the counts
    wire [5:0] sum_0  = count_0 + count_1;
    wire [5:0] sum_1  = count_2 + count_3;
    wire [5:0] sum_2  = count_4 + count_5;
    wire [5:0] sum_3  = count_6 + count_7;
    wire [5:0] sum_4  = count_8 + count_9;
    wire [5:0] sum_5  = count_10 + count_11;
    wire [5:0] sum_6  = count_12 + count_13;
    wire [5:0] sum_7  = count_14 + count_15;
    wire [5:0] sum_8  = count_16 + count_17;
    wire [5:0] sum_9  = count_18 + count_19;
    wire [5:0] sum_10 = count_20 + count_21;
    wire [5:0] sum_11 = count_22 + count_23;
    wire [5:0] sum_12 = count_24 + count_25;
    wire [5:0] sum_13 = count_26 + count_27;
    wire [5:0] sum_14 = count_28 + count_29;
    wire [5:0] sum_15 = count_30 + {2'b0, count_31};

    wire [6:0] sum_16 = sum_0 + sum_1;
    wire [6:0] sum_17 = sum_2 + sum_3;
    wire [6:0] sum_18 = sum_4 + sum_5;
    wire [6:0] sum_19 = sum_6 + sum_7;
    wire [6:0] sum_20 = sum_8 + sum_9;
    wire [6:0] sum_21 = sum_10 + sum_11;
    wire [6:0] sum_22 = sum_12 + sum_13;
    wire [6:0] sum_23 = sum_14 + sum_15;

    wire [7:0] sum_24 = sum_16 + sum_17;
    wire [7:0] sum_25 = sum_18 + sum_19;
    wire [7:0] sum_26 = sum_20 + sum_21;
    wire [7:0] sum_27 = sum_22 + sum_23;

    wire [8:0] sum_28 = sum_24 + sum_25;
    wire [8:0] sum_29 = sum_26 + sum_27;

    assign out = sum_28[7:0] + sum_29[7:0];

endmodule