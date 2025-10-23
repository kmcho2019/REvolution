module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output reg  [7:0] out
);

    // Function to rotate left by N bits
    function [7:0] rotate_left;
        input [7:0] data;
        input integer n;
        begin
            rotate_left = (data << n) | (data >> (8 - n));
        end
    endfunction

    always @(*) begin
        // Start with input
        reg [7:0] tmp;
        tmp = in;

        // Rotate by 4 bits if ctrl[2] set
        if (ctrl[2])
            tmp = rotate_left(tmp, 4);

        // Rotate by 2 bits if ctrl[1] set
        if (ctrl[1])
            tmp = rotate_left(tmp, 2);

        // Rotate by 1 bit if ctrl[0] set
        if (ctrl[0])
            tmp = rotate_left(tmp, 1);

        out = tmp;
    end

endmodule