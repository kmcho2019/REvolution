module multi_16bit (
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
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 5'b00000;
        areg <= 16'b0000000000000000;
        breg <= 16'b0000000000000000;
        yout_r <= 32'b00000000000000000000000000000000;
        done_r <= 1'b0;
    end else if (start) begin
        if (i == 5'b00000) begin
            areg <= ain;
            breg <= bin;
        end
        i <= i + 1'b1;
        if (i == 5'b10000) begin
            done_r <= 1'b1;
        end else if (i == 5'b10001) begin
            done_r <= 1'b0;
            i <= 5'b00000;
        end
        if ((areg >> (i - 1'b1)) & 1'b1) begin
            yout_r <= yout_r + (breg << (i - 1'b1));
        end
    end else begin
        i <= 5'b00000;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule