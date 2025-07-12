module TopModule(
    input [254:0] in,
    output [7:0] out
);
    wire [50:0] count_5bit;
    wire [15:0] count_6bit;
    wire [3:0] count_7bit;
    wire [7:0] count_8bit;

    // Count the number of '1's in each 5-bit chunk
    genvar i;
    generate
        for (i = 0; i < 51; i = i + 1) begin
            five_bit_counter five_bit_counter_inst(
               .in(in[5*i+4:5*i]),
               .out(count_5bit[i])
            );
        end
    endgenerate

    // Add up the counts from each 5-bit chunk
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin
            six_bit_adder six_bit_adder_inst(
               .in({count_5bit[5*j+4], count_5bit[5*j+3], count_5bit[5*j+2], count_5bit[5*j+1], count_5bit[5*j], count_5bit[5*j-1]}),
               .out(count_6bit[j])
            );
        end
    endgenerate

    // Add up the counts from each 6-bit chunk
    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin
            seven_bit_adder seven_bit_adder_inst(
               .in({count_6bit[4*k+3], count_6bit[4*k+2], count_6bit[4*k+1], count_6bit[4*k]}),
               .out(count_7bit[k])
            );
        end
    endgenerate

    // Add up the counts from each 7-bit chunk
    eight_bit_adder eight_bit_adder_inst(
       .in({count_7bit[3], count_7bit[2], count_7bit[1], count_7bit[0]}),
       .out(count_8bit)
    );

    assign out = count_8bit;
endmodule

module five_bit_counter(
    input [4:0] in,
    output [2:0] out
);
    reg [2:0] count;
    always @(in) begin
        count = 0;
        for (int i = 0; i < 5; i++) begin
            if (in[i] == 1'b1) begin
                count = count + 1;
            end
        end
    end
    assign out = count;
endmodule

module six_bit_adder(
    input [5:0] in,
    output [5:0] out
);
    reg [5:0] count;
    always @(in) begin
        count = 0;
        for (int i = 0; i < 6; i++) begin
            if (in[i] == 1'b1) begin
                count = count + 1;
            end
        end
    end
    assign out = count;
endmodule

module seven_bit_adder(
    input [3:0] in,
    output [6:0] out
);
    reg [6:0] count;
    always @(in) begin
        count = 0;
        for (int i = 0; i < 4; i++) begin
            if (in[i] == 1'b1) begin
                count = count + 1;
            end
        end
    end
    assign out = count;
endmodule

module eight_bit_adder(
    input [3:0] in,
    output [7:0] out
);
    reg [7:0] count;
    always @(in) begin
        count = 0;
        for (int i = 0; i < 4; i++) begin
            if (in[i] == 1'b1) begin
                count = count + 1;
            end
        end
    end
    assign out = count;
endmodule