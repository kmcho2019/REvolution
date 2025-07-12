module TopModule(
    input   [254:0] in,
    output  [7:0] out
);

reg [7:0] out_reg;

// Divide the 255-bit input into 8 groups of 32 bits
// and count the number of '1's in each group
reg [7:0] count0, count1, count2, count3, count4, count5, count6, count7;
reg [4:0] count_0, count_1, count_2, count_3, count_4, count_5, count_6, count_7;

// Level 1: Count the number of '1's in each group of 8 bits
always @(in) begin
    count_0 = {in[7:0], 5'd0} + {8{1'b1}};
    count_1 = {in[15:8], 5'd0} + {8{1'b1}};
    count_2 = {in[23:16], 5'd0} + {8{1'b1}};
    count_3 = {in[31:24], 5'd0} + {8{1'b1}};
    count_4 = {in[39:32], 5'd0} + {8{1'b1}};
    count_5 = {in[47:40], 5'd0} + {8{1'b1}};
    count_6 = {in[55:48], 5'd0} + {8{1'b1}};
    count_7 = {in[63:56], 5'd0} + {8{1'b1}};

    count_0 = {in[71:64], 5'd0} + {8{1'b1}};
    count_1 = {in[79:72], 5'd0} + {8{1'b1}};
    count_2 = {in[87:80], 5'd0} + {8{1'b1}};
    count_3 = {in[95:88], 5'd0} + {8{1'b1}};
    count_4 = {in[103:96], 5'd0} + {8{1'b1}};
    count_5 = {in[111:104], 5'd0} + {8{1'b1}};
    count_6 = {in[119:112], 5'd0} + {8{1'b1}};
    count_7 = {in[127:120], 5'd0} + {8{1'b1}};

    count_0 = {in[135:128], 5'd0} + {8{1'b1}};
    count_1 = {in[143:136], 5'd0} + {8{1'b1}};
    count_2 = {in[151:144], 5'd0} + {8{1'b1}};
    count_3 = {in[159:152], 5'd0} + {8{1'b1}};
    count_4 = {in[167:160], 5'd0} + {8{1'b1}};
    count_5 = {in[175:168], 5'd0} + {8{1'b1}};
    count_6 = {in[183:176], 5'd0} + {8{1'b1}};
    count_7 = {in[191:184], 5'd0} + {8{1'b1}};

    count_0 = {in[199:192], 5'd0} + {8{1'b1}};
    count_1 = {in[207:200], 5'd0} + {8{1'b1}};
    count_2 = {in[215:208], 5'd0} + {8{1'b1}};
    count_3 = {in[223:216], 5'd0} + {8{1'b1}};
    count_4 = {in[231:224], 5'd0} + {8{1'b1}};
    count_5 = {in[239:232], 5'd0} + {8{1'b1}};
    count_6 = {in[247:240], 5'd0} + {8{1'b1}};
    count_7 = {in[254:248], 5'd0} + {7{1'b1}};
end

always @(count_0, count_1, count_2, count_3, count_4, count_5, count_6, count_7) begin
    count0 = count_0 + count_1 + count_2 + count_3;
    count1 = count_4 + count_5 + count_6 + count_7;
end

always @(count0, count1) begin
    out_reg = count0 + count1;
end

assign out = out_reg;

endmodule