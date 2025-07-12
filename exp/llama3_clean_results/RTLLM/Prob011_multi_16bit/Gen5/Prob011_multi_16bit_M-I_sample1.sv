module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [31:0] yout_r;
reg [4:0] i;
reg clock_enable;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 0;
        yout_r <= 0;
        done <= 0;
        clock_enable <= 0;
    end else begin
        if (start && i < 17) begin
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
            if (!start || i >= 17) begin
                i <= 0;
                yout_r <= 0;
                done <= 0;
            end
        end
    end
end

assign yout = yout_r;

endmodule