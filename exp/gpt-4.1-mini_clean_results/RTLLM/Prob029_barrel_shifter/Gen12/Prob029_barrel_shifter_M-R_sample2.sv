module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output reg  [7:0] out
);
    reg [7:0] stage4;
    reg [7:0] stage2;
    reg [7:0] stage1;

    always @(*) begin
        // Rotate left by 4 bits if ctrl[2] is set
        stage4 = ctrl[2] ? {in[3:0], in[7:4]} : in;

        // Rotate left by 2 bits if ctrl[1] is set
        stage2 = ctrl[1] ? {stage4[5:0], stage4[7:6]} : stage4;

        // Rotate left by 1 bit if ctrl[0] is set
        stage1 = ctrl[0] ? {stage2[6:0], stage2[7]} : stage2;

        // Final output
        out = stage1;
    end

endmodule