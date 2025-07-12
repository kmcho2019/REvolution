module popcount_32bit(input [31:0] in, output [5:0] out);
    assign out = {in[31], in[30], in[29], in[28], in[27], in[26]} + 
                 {in[25], in[24], in[23], in[22], in[21], in[20]} + 
                 {in[19], in[18], in[17], in[16], in[15], in[14]} + 
                 {in[13], in[12], in[11], in[10], in[9],  in[8]} + 
                 {in[7],  in[6],  in[5],  in[4],  in[3],  in[2]} + 
                 {in[1],  in[0],  1'b0,  1'b0,  1'b0,  1'b0};
endmodule

module popcount_7bit(input [6:0] in, output [2:0] out);
    assign out = {in[6], in[5], in[4]} + {in[3], in[2], in[1]} + {in[0], 1'b0, 1'b0};
endmodule

module TopModule(input [254:0] in, output [7:0] out);
    wire [5:0] p1, p2, p3, p4, p5, p6, p7, p8;
    wire [2:0] p9;
    
    popcount_32bit u1(.in(in[254:223]), .out(p1));
    popcount_32bit u2(.in(in[222:191]), .out(p2));
    popcount_32bit u3(.in(in[190:159]), .out(p3));
    popcount_32bit u4(.in(in[158:127]), .out(p4));
    popcount_32bit u5(.in(in[126:95]), .out(p5));
    popcount_32bit u6(.in(in[94:63]), .out(p6));
    popcount_32bit u7(.in(in[62:31]), .out(p7));
    popcount_32bit u8(.in(in[30:0] | {25{1'b0}}), .out(p8));
    popcount_7bit u9(.in(in[30:24]), .out(p9));
    
    assign out = p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 - 8'd8 + p9;
endmodule