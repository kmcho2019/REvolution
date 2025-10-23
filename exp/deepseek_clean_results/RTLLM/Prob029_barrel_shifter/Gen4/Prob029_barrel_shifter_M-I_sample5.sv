module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Right rotation implementation (standard barrel shifter behavior)
    // Each stage performs independent rotation controlled by ctrl bits
    wire [7:0] rotated_4 = ctrl[2] ? {in[3:0], in[7:4]} : in;
    wire [7:0] rotated_2 = ctrl[1] ? {rotated_4[1:0], rotated_4[7:2]} : rotated_4;
    wire [7:0] rotated_1 = ctrl[0] ? {rotated_2[0], rotated_2[7:1]} : rotated_2;
    
    assign out = rotated_1;
endmodule