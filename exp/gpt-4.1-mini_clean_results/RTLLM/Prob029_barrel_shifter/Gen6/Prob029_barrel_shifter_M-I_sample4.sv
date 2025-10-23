module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Function to perform 8-bit left rotate by n positions
    function [7:0] rotate_left;
        input [7:0] value;
        input [2:0] amount;  // 0 to 7
        begin
            rotate_left = (value << amount) | (value >> (8 - amount));
        end
    endfunction

    wire [7:0] rot4, rot2, rot1;

    // Rotate by 4 if ctrl[2] is set
    assign rot4 = ctrl[2] ? rotate_left(in, 4) : in;

    // Rotate by 2 if ctrl[1] is set (on top of previous result)
    assign rot2 = ctrl[1] ? rotate_left(rot4, 2) : rot4;

    // Rotate by 1 if ctrl[0] is set (on top of previous result)
    assign out = ctrl[0] ? rotate_left(rot2, 1) : rot2;

endmodule