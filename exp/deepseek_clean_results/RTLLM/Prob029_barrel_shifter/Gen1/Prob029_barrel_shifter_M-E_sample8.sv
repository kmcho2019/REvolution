module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Pre-compute all possible rotated versions
    wire [7:0] rotated [0:7];
    
    assign rotated[0] = in;                        // No shift
    assign rotated[1] = {in[0], in[7:1]};         // Rotate right by 1
    assign rotated[2] = {in[1:0], in[7:2]};       // Rotate right by 2
    assign rotated[3] = {in[2:0], in[7:3]};       // Rotate right by 3
    assign rotated[4] = {in[3:0], in[7:4]};       // Rotate right by 4
    assign rotated[5] = {in[4:0], in[7:5]};       // Rotate right by 5
    assign rotated[6] = {in[5:0], in[7:6]};       // Rotate right by 6
    assign rotated[7] = {in[6:0], in[7]};         // Rotate right by 7

    // Output selection based on control signal
    assign out = rotated[ctrl];
endmodule