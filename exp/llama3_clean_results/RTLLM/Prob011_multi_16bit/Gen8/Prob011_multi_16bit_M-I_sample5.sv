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
reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg done_r;
reg clock_enable;

assign yout = yout_r;
assign done = done_r;

// Pipelining stages
reg [15:0] areg_pipe1;
reg [15:0] breg_pipe1;
reg [31:0] yout_r_pipe1;

always @(posedge clk) begin
    if (!rst_n) begin
        i <= 5'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
        clock_enable <= 1'b0;
        areg_pipe1 <= 16'd0;
        breg_pipe1 <= 16'd0;
        yout_r_pipe1 <= 32'd0;
    end else begin
        if (start && i < 5'd17) begin
            clock_enable <= 1'b1;
            if (i == 5'd0) begin
                areg_pipe1 <= ain;
                breg_pipe1 <= bin;
                yout_r_pipe1 <= 32'd0;
            end else begin
                areg_pipe1 <= areg;
                breg_pipe1 <= breg;
                if (areg[i-1] == 1'b1) begin
                    yout_r_pipe1 <= yout_r + (breg << (i-1));
                end else begin
                    yout_r_pipe1 <= yout_r;
                end
            end
            areg <= areg_pipe1;
            breg <= breg_pipe1;
            yout_r <= yout_r_pipe1;
            i <= i + 1'b1;
            if (i == 5'd16) begin
                done_r <= 1'b1;
            end
        end else begin
            clock_enable <= 1'b0;
            if (!start || i >= 5'd17) begin
                i <= 5'd0;
                areg <= 16'd0;
                breg <= 16'd0;
                yout_r <= 32'd0;
                done_r <= 1'b0;
            end
        end
    end
end

endmodule