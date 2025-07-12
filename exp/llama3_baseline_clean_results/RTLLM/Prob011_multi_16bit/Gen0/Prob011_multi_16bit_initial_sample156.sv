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
reg [3:0] i;
reg [15:0] areg;
reg [15:0] breg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 4'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        done <= 1'b0;
    end else if (start) begin
        if (i < 16) begin
            if (i == 4'd0) begin
                areg <= ain;
                breg <= bin;
            end
            if (areg[i-1] == 1'b1) begin
                yout_r <= yout_r + ({16'd0, breg} << (i-1));
            end
            i <= i + 1'b1;
        end else if (i == 16) begin
            done <= 1'b1;
        end else if (i == 17) begin
            i <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
            done <= 1'b0;
        end
    end else begin
        i <= 4'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        done <= 1'b0;
    end
end

assign yout = yout_r;

endmodule