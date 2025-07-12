module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output reg  [7:0] out
);

    // Function to perform a rotate-left by `shift` bits on 8-bit vector
    function [7:0] rotate_left;
        input [7:0] data;
        input integer shift;
        begin
            rotate_left = (data << shift) | (data >> (8 - shift));
        end
    endfunction

    always @(*) begin
        reg [7:0] temp;

        temp = in;

        if (ctrl[2])
            temp = rotate_left(temp, 4);

        if (ctrl[1])
            temp = rotate_left(temp, 2);

        if (ctrl[0])
            temp = rotate_left(temp, 1);

        out = temp;
    end

endmodule