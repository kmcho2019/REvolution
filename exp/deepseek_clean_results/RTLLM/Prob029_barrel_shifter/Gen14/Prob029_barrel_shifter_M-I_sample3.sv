module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Combined right rotation in one operation
    assign out = (ctrl[2] ? {in[3:0], in[7:4]} : 8'b0) |
                 (ctrl[1] ? {in[1:0], in[7:2]} : 8'b0) |
                 (ctrl[0] ? {in[0],   in[7:1]} : 8'b0) |
                 ((ctrl == 3'b0) ? in : 8'b0);
endmodule