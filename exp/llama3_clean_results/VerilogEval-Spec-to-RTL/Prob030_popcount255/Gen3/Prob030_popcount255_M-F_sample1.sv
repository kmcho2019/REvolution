module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Divide the input vector into 8 segments of 32 bits (except the last segment which will be 31 bits)
    wire [31:0] seg1 = in[31:0];
    wire [31:0] seg2 = in[63:32];
    wire [31:0] seg3 = in[95:64];
    wire [31:0] seg4 = in[127:96];
    wire [31:0] seg5 = in[159:128];
    wire [31:0] seg6 = in[191:160];
    wire [31:0] seg7 = in[223:192];
    wire [30:0] seg8 = in[254:224];

    // Calculate the count of '1's in each segment
    wire [4:0] count1;
    wire [4:0] count2;
    wire [4:0] count3;
    wire [4:0] count4;
    wire [4:0] count5;
    wire [4:0] count6;
    wire [4:0] count7;
    wire [4:0] count8;

    // Count the '1's in each segment using a series of adders
    assign count1 = ({1'b0, {16{1'b0}}} + 
                    (seg1[31:16] == 32'hFFFFFFFF ? 5'd16 : (|(seg1[31:16]) ? 5'd1 : 5'd0)) + 
                    (seg1[15:0] == 16'hFFFF ? 5'd16 : (|(seg1[15:0]) ? 5'd1 : 5'd0)));

    assign count2 = ({1'b0, {16{1'b0}}} + 
                    (seg2[31:16] == 32'hFFFFFFFF ? 5'd16 : (|(seg2[31:16]) ? 5'd1 : 5'd0)) + 
                    (seg2[15:0] == 16'hFFFF ? 5'd16 : (|(seg2[15:0]) ? 5'd1 : 5'd0)));

    assign count3 = ({1'b0, {16{1'b0}}} + 
                    (seg3[31:16] == 32'hFFFFFFFF ? 5'd16 : (|(seg3[31:16]) ? 5'd1 : 5'd0)) + 
                    (seg3[15:0] == 16'hFFFF ? 5'd16 : (|(seg3[15:0]) ? 5'd1 : 5'd0)));

    assign count4 = ({1'b0, {16{1'b0}}} + 
                    (seg4[31:16] == 32'hFFFFFFFF ? 5'd16 : (|(seg4[31:16]) ? 5'd1 : 5'd0)) + 
                    (seg4[15:0] == 16'hFFFF ? 5'd16 : (|(seg4[15:0]) ? 5'd1 : 5'd0)));

    assign count5 = ({1'b0, {16{1'b0}}} + 
                    (seg5[31:16] == 32'hFFFFFFFF ? 5'd16 : (|(seg5[31:16]) ? 5'd1 : 5'd0)) + 
                    (seg5[15:0] == 16'hFFFF ? 5'd16 : (|(seg5[15:0]) ? 5'd1 : 5'd0)));

    assign count6 = ({1'b0, {16{1'b0}}} + 
                    (seg6[31:16] == 32'hFFFFFFFF ? 5'd16 : (|(seg6[31:16]) ? 5'd1 : 5'd0)) + 
                    (seg6[15:0] == 16'hFFFF ? 5'd16 : (|(seg6[15:0]) ? 5'd1 : 5'd0)));

    assign count7 = ({1'b0, {16{1'b0}}} + 
                    (seg7[31:16] == 32'hFFFFFFFF ? 5'd16 : (|(seg7[31:16]) ? 5'd1 : 5'd0)) + 
                    (seg7[15:0] == 16'hFFFF ? 5'd16 : (|(seg7[15:0]) ? 5'd1 : 5'd0)));

    assign count8 = ({1'b0, {16{1'b0}}} + 
                    (seg8[30:16] == 16'hFFFF ? 5'd16 : (|(seg8[30:16]) ? 5'd1 : 5'd0)) + 
                    (seg8[15:0] == 16'hFFFF ? 5'd16 : (|(seg8[15:0]) ? 5'd1 : 5'd0)));

    // Combine the counts from each segment to produce the final output
    assign out = count1 + count2 + count3 + count4 + count5 + count6 + count7 + count8;

endmodule