module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg [3:0] i;
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        areg <= 16'h0000;
        breg <= 16'h0000;
        yout_r <= 32'h0000;
        i <= 4'h0;
        done_r <= 1'b0;
    end else if (start) begin
        if (i == 4'h0) begin
            areg <= ain;
            breg <= bin;
        end
        if (i < 4'h10) begin
            if (areg[15 - i]) begin
                yout_r <= yout_r + (breg << (i - 1));
            end
            areg <= areg << 1;
            i <= i + 1;
        end else if (i == 4'h10) begin
            done_r <= 1'b1;
            i <= i + 1;
        end else begin
            i <= 4'h0;
            done_r <= 1'b0;
        end
    end else begin
        i <= 4'h0;
        done_r <= 1'b0;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule