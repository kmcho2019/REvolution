module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [31:0] yout_r;
reg [15:0] areg;
reg [15:0] breg;
reg [4:0] i;
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        yout_r <= 32'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        i <= 5'd0;
        done_r <= 1'b0;
    end else begin
        if (!start) begin
            i <= 5'd0;
        end else if (i < 17) begin
            i <= i + 1'b1;
        end

        if (i == 16) begin
            done_r <= 1'b1;
        end else if (i == 17) begin
            done_r <= 1'b0;
        end

        if (i == 1) begin
            areg <= ain;
            breg <= bin;
        end

        if (i > 1 && i < 17) begin
            if (areg[15 - (i - 1)]) begin
                yout_r <= yout_r + (breg << (i - 1));
            end
        end

        if (i == 17) begin
            yout_r <= 32'd0;
            areg <= 16'd0;
            breg <= 16'd0;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule