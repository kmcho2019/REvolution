module counter_32bit(input [31:0] in, output [5:0] count);
    reg [5:0] temp_count;
    always @(*) begin
        temp_count = 0;
        for (int i = 0; i < 32; i++) begin
            temp_count = temp_count + in[i];
        end
    end
    assign count = temp_count;
endmodule

module counter_7bit(input [6:0] in, output [2:0] count);
    reg [2:0] temp_count;
    always @(*) begin
        temp_count = 0;
        for (int i = 0; i < 7; i++) begin
            temp_count = temp_count + in[i];
        end
    end
    assign count = temp_count;
endmodule

module counter_8bit(input [7:0] in, output [3:0] count);
    reg [3:0] temp_count;
    always @(*) begin
        temp_count = 0;
        for (int i = 0; i < 8; i++) begin
            temp_count = temp_count + in[i];
        end
    end
    assign count = temp_count;
endmodule

module TopModule(input [254:0] in, output [7:0] out);
    wire [5:0] count_32bit_0;
    wire [5:0] count_32bit_1;
    wire [5:0] count_32bit_2;
    wire [5:0] count_32bit_3;
    wire [5:0] count_32bit_4;
    wire [5:0] count_32bit_5;
    wire [5:0] count_32bit_6;
    wire [5:0] count_32bit_7;
    wire [2:0] count_7bit;
    wire [3:0] temp_sum_0;
    wire [3:0] temp_sum_1;
    wire [3:0] temp_sum_2;
    wire [3:0] temp_sum_3;

    counter_32bit u0(.in(in[31:0]), .count(count_32bit_0));
    counter_32bit u1(.in(in[63:32]), .count(count_32bit_1));
    counter_32bit u2(.in(in[95:64]), .count(count_32bit_2));
    counter_32bit u3(.in(in[127:96]), .count(count_32bit_3));
    counter_32bit u4(.in(in[159:128]), .count(count_32bit_4));
    counter_32bit u5(.in(in[191:160]), .count(count_32bit_5));
    counter_32bit u6(.in(in[223:192]), .count(count_32bit_6));
    counter_32bit u7(.in(in[254:224]), .count(count_32bit_7));
    counter_7bit u8(.in(in[6:0]), .count(count_7bit));

    assign temp_sum_0 = count_32bit_0 + count_32bit_1;
    assign temp_sum_1 = count_32bit_2 + count_32bit_3;
    assign temp_sum_2 = count_32bit_4 + count_32bit_5;
    assign temp_sum_3 = count_32bit_6 + count_32bit_7;

    assign out[7:0] = {1'b0, 3'b0, count_7bit} + {2'b0, temp_sum_0} + {2'b0, temp_sum_1} + {2'b0, temp_sum_2} + {2'b0, temp_sum_3} + {5'b0, count_32bit_0} + {5'b0, count_32bit_1} + {5'b0, count_32bit_2} + {5'b0, count_32bit_3} + {5'b0, count_32bit_4} + {5'b0, count_32bit_5} + {5'b0, count_32bit_6} + {5'b0, count_32bit_7};

endmodule