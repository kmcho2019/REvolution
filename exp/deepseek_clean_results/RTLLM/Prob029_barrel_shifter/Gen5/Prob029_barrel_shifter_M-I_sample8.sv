module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Left rotation implementation
    wire [7:0] rotated_4 = ctrl[2] ? {in[3:0], in[7:4]} : in;
    wire [7:0] rotated_2 = ctrl[1] ? {rotated_4[5:0], rotated_4[7:6]} : rotated_4;
    wire [7:0] rotated_1 = ctrl[0] ? {rotated_2[6:0], rotated_2[7]} : rotated_2;
    
    assign out = rotated_1;
endmodule