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
reg [4:0] i;
reg [15:0] areg;
reg [15:0] breg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        yout_r <= 0;
        i <= 0;
        areg <= 0;
        breg <= 0;
        done <= 0;
    end else if (start) begin
        areg <= ain;
        breg <= bin;
        i <= 0;
        yout_r <= 0;
        done <= 0;
    end else if (i < 16) begin
        if (areg[0] == 1'b1) begin
            yout_r <= yout_r + (breg << i);
        end
        areg <= areg >> 1;
        i <= i + 1;
    end else if (i == 16) begin
        done <= 1;
    end
end

assign yout = yout_r;

endmodule