module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Pre-compute all possible rotated versions
    wire [7:0] rotated [0:7];
    assign rotated[0] = in;                            // no shift
    assign rotated[1] = {in[6:0], in[7]};              // rotate right 1
    assign rotated[2] = {in[5:0], in[7:6]};            // rotate right 2
    assign rotated[3] = {in[4:0], in[7:5]};            // rotate right 3
    assign rotated[4] = {in[3:0], in[7:4]};            // rotate right 4
    assign rotated[5] = {in[2:0], in[7:3]};            // rotate right 5
    assign rotated[6] = {in[1:0], in[7:2]};            // rotate right 6
    assign rotated[7] = {in[0], in[7:1]};              // rotate right 7

    // Select the appropriate rotation based on control
    assign out = rotated[ctrl];
endmodule