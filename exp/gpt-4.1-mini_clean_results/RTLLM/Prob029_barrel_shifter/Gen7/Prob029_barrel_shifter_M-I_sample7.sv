module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Function to rotate left by n positions in 8-bit vector
    function [7:0] rotate_left;
        input [7:0] data;
        input [2:0] shift_amount; // max 7
        begin
            rotate_left = (data << shift_amount) | (data >> (8 - shift_amount));
        end
    endfunction

    wire [7:0] stage1, stage2, stage3;

    // Stage 1: conditional rotate by 4
    wire [7:0] rotated4 = rotate_left(in, 3'd4);
    assign stage1 = ctrl[2] ? rotated4 : in;

    // Stage 2: conditional rotate by 2
    wire [7:0] rotated2 = rotate_left(stage1, 3'd2);
    assign stage2 = ctrl[1] ? rotated2 : stage1;

    // Stage 3: conditional rotate by 1
    wire [7:0] rotated1 = rotate_left(stage2, 3'd1);
    assign stage3 = ctrl[0] ? rotated1 : stage2;

    assign out = stage3;

endmodule