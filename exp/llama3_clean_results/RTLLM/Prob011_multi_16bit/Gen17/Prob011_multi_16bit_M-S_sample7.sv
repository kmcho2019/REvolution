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
reg [15:0] areg, breg;

always @(posedge clk) begin
    if (!rst_n) begin
        i <= 5'd0;
        yout_r <= 32'd0;
        done <= 1'b0;
    end else if (start && i < 5'd16) begin
        if (i == 5'd0) begin
            areg <= ain;
            breg <= bin;
            yout_r <= 32'd0;
        end
        if (i > 5'd0) begin
            if (areg[i-1] == 1'b1) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end
        i <= i + 1'b1;
        done <= (i == 5'd16) ? 1'b1 : 1'b0;
    end else begin
        i <= 5'd0;
        yout_r <= 32'd0;
        done <= 1'b0;
    end
end

assign yout = yout_r;

endmodule