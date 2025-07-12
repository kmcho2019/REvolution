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
reg [15:0] areg;
reg [15:0] breg;

always @(posedge clk) begin
    if (!rst_n) begin
        i <= 5'd0;
        yout_r <= 32'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        done <= 1'b0;
    end else if (start) begin
        if (i == 5'd0) begin
            areg <= ain;
            breg <= bin;
        end
        if (i < 5'd16) begin
            if (areg[i] == 1'b1) begin
                yout_r <= yout_r + (breg << i);
            end
            i <= i + 1'b1;
        end
        if (i == 5'd16) begin
            done <= 1'b1;
        end
    end else begin
        i <= 5'd0;
        yout_r <= 32'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        done <= 1'b0;
    end
end

assign yout = yout_r;

endmodule