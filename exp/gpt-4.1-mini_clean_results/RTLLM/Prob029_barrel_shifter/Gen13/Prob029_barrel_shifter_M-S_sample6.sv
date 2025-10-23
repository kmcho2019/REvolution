module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output reg  [7:0] out
);

    always @* begin
        // Start with input value
        reg [7:0] temp;
        temp = in;

        // Rotate left by 4 if ctrl[2] set
        if (ctrl[2]) temp = {temp[3:0], temp[7:4]};
        // Rotate left by 2 if ctrl[1] set
        if (ctrl[1]) temp = {temp[5:0], temp[7:6]};
        // Rotate left by 1 if ctrl[0] set
        if (ctrl[0]) temp = {temp[6:0], temp[7]};

        out = temp;
    end

endmodule