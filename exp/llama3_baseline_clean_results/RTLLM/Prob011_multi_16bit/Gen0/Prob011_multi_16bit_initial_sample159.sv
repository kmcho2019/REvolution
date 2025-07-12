module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg [4:0] i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        i <= 5'd0;
        done <= 1'd0;
    end else if (start) begin
        if (i == 5'd0) begin
            areg <= ain;
            breg <= bin;
            yout_r <= 32'd0;
            i <= i + 1'd1;
        end else if (i < 5'd17) begin
            if (areg[i-1] == 1'd1) begin
                yout_r <= yout_r + (breg << (i-1));
            end
            i <= i + 1'd1;
        end
        if (i == 5'd16) begin
            done <= 1'd1;
        end else if (i == 5'd17) begin
            done <= 1'd0;
            i <= 5'd0;
        end
    end else begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        i <= 5'd0;
        done <= 1'd0;
    end
end

always @(*) begin
    yout = yout_r;
end

endmodule