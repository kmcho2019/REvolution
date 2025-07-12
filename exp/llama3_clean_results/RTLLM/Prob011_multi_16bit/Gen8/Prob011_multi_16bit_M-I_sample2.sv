module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i;
reg [31:0] yout_r;
reg clock_enable;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 0;
        yout_r <= 0;
        done <= 0;
        clock_enable <= 0;
    end else begin
        if (start) begin
            clock_enable <= 1;
            if (i == 0) begin
                yout_r <= 0;
            end
            if (i > 0 && i < 17) begin
                if (ain[i-1]) begin
                    yout_r <= yout_r + (bin << (i-1));
                end
            end
            i <= i + 1;
            if (i == 16) begin
                done <= 1;
            end
        end else begin
            clock_enable <= 0;
            i <= 0;
            yout_r <= 0;
            done <= 0;
        end
        if (i == 17) begin
            done <= 0;
        end
    end
end

always @(posedge clk) begin
    if (clock_enable) begin
        // Pipelined multiplication operation
        if (i == 1) begin
            yout_r <= yout_r + (bin << 0);
        end else if (i == 2) begin
            yout_r <= yout_r + (bin << 1);
        end else if (i == 3) begin
            yout_r <= yout_r + (bin << 2);
        end else if (i == 4) begin
            yout_r <= yout_r + (bin << 3);
        end else if (i == 5) begin
            yout_r <= yout_r + (bin << 4);
        end else if (i == 6) begin
            yout_r <= yout_r + (bin << 5);
        end else if (i == 7) begin
            yout_r <= yout_r + (bin << 6);
        end else if (i == 8) begin
            yout_r <= yout_r + (bin << 7);
        end else if (i == 9) begin
            yout_r <= yout_r + (bin << 8);
        end else if (i == 10) begin
            yout_r <= yout_r + (bin << 9);
        end else if (i == 11) begin
            yout_r <= yout_r + (bin << 10);
        end else if (i == 12) begin
            yout_r <= yout_r + (bin << 11);
        end else if (i == 13) begin
            yout_r <= yout_r + (bin << 12);
        end else if (i == 14) begin
            yout_r <= yout_r + (bin << 13);
        end else if (i == 15) begin
            yout_r <= yout_r + (bin << 14);
        end else if (i == 16) begin
            yout_r <= yout_r + (bin << 15);
        end
    end
end

assign yout = yout_r;

endmodule