module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output reg  [7:0] out
);
    always @* begin
        // Start from input
        reg [7:0] tmp;
        tmp = in;

        // Rotate left by 4 if ctrl[2] is set
        if (ctrl[2])
            tmp = {tmp[3:0], tmp[7:4]};
        // Rotate left by 2 if ctrl[1] is set
        if (ctrl[1])
            tmp = {tmp[5:0], tmp[7:6]};
        // Rotate left by 1 if ctrl[0] is set
        if (ctrl[0])
            tmp = {tmp[6:0], tmp[7]};

        out = tmp;
    end
endmodule