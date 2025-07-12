module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [15:0] areg, breg; // Input registers
reg [31:0] stage0, stage1, stage2, stage3, stage4, stage5, stage6, stage7, stage8, stage9, stage10, stage11, stage12, stage13, stage14, stage15; // Pipeline stages
reg [4:0] i; // Counter for pipeline control
reg [31:0] yout_r; // Output register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        areg <= 0;
        breg <= 0;
        stage0 <= 0;
        stage1 <= 0;
        stage2 <= 0;
        stage3 <= 0;
        stage4 <= 0;
        stage5 <= 0;
        stage6 <= 0;
        stage7 <= 0;
        stage8 <= 0;
        stage9 <= 0;
        stage10 <= 0;
        stage11 <= 0;
        stage12 <= 0;
        stage13 <= 0;
        stage14 <= 0;
        stage15 <= 0;
        i <= 0;
        yout_r <= 0;
        done <= 0;
    end else begin
        if (start) begin
            areg <= ain;
            breg <= bin;
            i <= 0;
            stage0 <= 0;
            stage1 <= 0;
            stage2 <= 0;
            stage3 <= 0;
            stage4 <= 0;
            stage5 <= 0;
            stage6 <= 0;
            stage7 <= 0;
            stage8 <= 0;
            stage9 <= 0;
            stage10 <= 0;
            stage11 <= 0;
            stage12 <= 0;
            stage13 <= 0;
            stage14 <= 0;
            stage15 <= 0;
        end

        if (i < 16) begin
            case (i)
                0: stage0 <= (areg[0] ? (breg << 0) : 0);
                1: stage1 <= (areg[1] ? (breg << 1) : 0);
                2: stage2 <= (areg[2] ? (breg << 2) : 0);
                3: stage3 <= (areg[3] ? (breg << 3) : 0);
                4: stage4 <= (areg[4] ? (breg << 4) : 0);
                5: stage5 <= (areg[5] ? (breg << 5) : 0);
                6: stage6 <= (areg[6] ? (breg << 6) : 0);
                7: stage7 <= (areg[7] ? (breg << 7) : 0);
                8: stage8 <= (areg[8] ? (breg << 8) : 0);
                9: stage9 <= (areg[9] ? (breg << 9) : 0);
                10: stage10 <= (areg[10] ? (breg << 10) : 0);
                11: stage11 <= (areg[11] ? (breg << 11) : 0);
                12: stage12 <= (areg[12] ? (breg << 12) : 0);
                13: stage13 <= (areg[13] ? (breg << 13) : 0);
                14: stage14 <= (areg[14] ? (breg << 14) : 0);
                15: stage15 <= (areg[15] ? (breg << 15) : 0);
            endcase
            i <= i + 1;
        end

        if (i == 16) begin
            yout_r <= stage0 + stage1 + stage2 + stage3 + stage4 + stage5 + stage6 + stage7 + stage8 + stage9 + stage10 + stage11 + stage12 + stage13 + stage14 + stage15;
            done <= 1;
        end
    end
end

assign yout = yout_r;

endmodule