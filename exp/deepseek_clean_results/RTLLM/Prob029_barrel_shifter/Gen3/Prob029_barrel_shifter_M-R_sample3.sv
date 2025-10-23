module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Single assignment with nested ternary operators
    assign out = ctrl[2] ? (ctrl[1] ? (ctrl[0] ? {in[0], in[7:1]} : {in[1:0], in[7:2]}) : 
                                 (ctrl[0] ? {in[3:0], in[7:5], in[4]} : {in[3:0], in[7:4]}) :
                  ctrl[1] ? (ctrl[0] ? {in[5:0], in[7:6]} : {in[1:0], in[7:2]}) :
                  ctrl[0] ? {in[0], in[7:1]} : in;

endmodule