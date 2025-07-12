module TopModule (
    input [7:0] in,
    output [2:0] pos
);

wire [1:0] group0 = in[1:0];
wire [1:0] group1 = in[3:2];
wire [1:0] group2 = in[5:4];
wire [1:0] group3 = in[7:6];

wire group0_valid = |group0;
wire group1_valid = |group1;
wire group2_valid = |group2;
wire group3_valid = |group3;

wire [1:0] group0_pos = group0[0] ? 2'b00 : 
                       group0[1] ? 2'b01 : 2'b00;
wire [1:0] group1_pos = group1[0] ? 2'b00 : 
                       group1[1] ? 2'b01 : 2'b00;
wire [1:0] group2_pos = group2[0] ? 2'b00 : 
                       group2[1] ? 2'b01 : 2'b00;
wire [1:0] group3_pos = group3[0] ? 2'b00 : 
                       group3[1] ? 2'b01 : 2'b00;

wire [2:0] stage0_pos = group0_valid ? {1'b0, group0_pos} :
                       group1_valid ? {1'b1, group1_pos} :
                       group2_valid ? {2'b10, group2_pos[0]} :
                       group3_valid ? {2'b11, group3_pos[0]} : 3'b000;

assign pos = stage0_pos;

endmodule