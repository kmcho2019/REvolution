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
reg [15:0] areg;
reg [15:0] breg;

assign yout = yout_r;
assign done = done_r;

always @(posedge clk) begin
    if (!rst_n) begin
        i <= 5'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
        areg <= 16'd0;
        breg <= 16'd0;
    end else begin
        if (start) begin
            if (i == 5'd0) begin
                areg <= ain;
                breg <= bin;
            end
            if (i < 5'd16) begin
                if (areg[i] == 1'b1) begin
                    yout_r <= yout_r + (breg << i);
                end
            end
            i <= i + 1'b1;
            if (i == 5'd16) begin
                done_r <= 1'b1;
            end
        end else begin
            i <= 5'd0;
            yout_r <= 32'd0;
            done_r <= 1'b0;
            areg <= 16'd0;
            breg <= 16'd0;
        end
    end
end

endmodule