module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);
    // Internal signals for each rotation stage
    reg [7:0] stage1, stage2;

    // Stage 1: 4-bit right rotation (controlled by ctrl[2])
    always @(*) begin
        if (ctrl[2])
            stage1 = {in[3:0], in[7:4]};  // Rotate right by 4
        else
            stage1 = in;
    end

    // Stage 2: 2-bit right rotation (controlled by ctrl[1])
    always @(*) begin
        if (ctrl[1])
            stage2 = {stage1[5:0], stage1[7:6]};  // Rotate right by 2
        else
            stage2 = stage1;
    end

    // Stage 3: 1-bit right rotation (controlled by ctrl[0])
    always @(*) begin
        if (ctrl[0])
            out = {stage2[0], stage2[7:1]};  // Rotate right by 1
        else
            out = stage2;
    end
endmodule