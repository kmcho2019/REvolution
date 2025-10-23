module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Function to perform right rotate by 'amt' bits on 8-bit input
    function [7:0] rotate_right;
        input [7:0] data;
        input [2:0] amt;
        begin
            // rotation = lower bits concatenated with upper bits
            rotate_right = (data >> amt) | (data << (8 - amt));
        end
    endfunction

    assign out = rotate_right(in, ctrl);

endmodule