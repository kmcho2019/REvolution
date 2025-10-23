module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);

    // Stage 1: Shift by 4 positions if ctrl[2] is high
    reg [7:0] stage1_out;
    always @(*) begin
        if (ctrl[2]) begin
            stage1_out = {in[3:0], in[7:4]};
        end else begin
            stage1_out = in;
        end
    end

    // Stage 2: Shift by 2 positions if ctrl[1] is high
    reg [7:0] stage2_out;
    always @(*) begin
        if (ctrl[1]) begin
            stage2_out = {stage1_out[5:0], stage1_out[7:6]};
        end else begin
            stage2_out = stage1_out;
        end
    end

    // Stage 3: Shift by 1 position if ctrl[0] is high
    always @(*) begin
        if (ctrl[0]) begin
            out = {stage2_out[6:0], stage2_out[7]};
        end else begin
            out = stage2_out;
        end
    end

endmodule