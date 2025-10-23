module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output reg  [7:0] out
);

    wire [7:0] rot_4, rot_2, rot_1;

    // Rotate left by 4 bits
    assign rot_4 = {in[3:0], in[7:4]};
    // Rotate left by 2 bits
    assign rot_2 = {in[5:0], in[7:6]};
    // Rotate left by 1 bit
    assign rot_1 = {in[6:0], in[7]};

    always @(*) begin
        // Start with input
        out = in;
        // Apply 4-bit rotation if ctrl[2] set
        if (ctrl[2]) out = rot_4;
        // Apply 2-bit rotation on intermediate result if ctrl[1] set
        if (ctrl[1]) out = {out[5:0], out[7:6]};
        // Apply 1-bit rotation on intermediate result if ctrl[0] set
        if (ctrl[0]) out = {out[6:0], out[7]};
    end

endmodule