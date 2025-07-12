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
reg done_r;
reg clock_enable;

always @(posedge clk) begin
    if (!rst_n) begin
        i <= 5'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
        clock_enable <= 1'b0;
    end else begin
        if (start) begin
            clock_enable <= 1'b1;
        end else begin
            clock_enable <= 1'b0;
        end

        if (clock_enable) begin
            if (i < 5'd16) begin
                if (i == 5'd0) begin
                    yout_r <= 32'd0;
                end
                if (ain[i] == 1'b1) begin
                    yout_r <= yout_r + (bin << i);
                end
                i <= i + 1'b1;
            end else if (i == 5'd16) begin
                done_r <= 1'b1;
                i <= i + 1'b1;
            end else begin
                i <= 5'd0;
                yout_r <= 32'd0;
                done_r <= 1'b0;
            end
        end else begin
            i <= 5'd0;
            yout_r <= 32'd0;
            done_r <= 1'b0;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule