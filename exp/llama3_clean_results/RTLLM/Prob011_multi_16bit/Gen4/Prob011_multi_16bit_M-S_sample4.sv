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
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done <= 0;
    end else if (start) begin
        if (i == 0) begin
            areg <= ain;
            breg <= bin;
            yout_r <= 0;
        end else if (i < 16) begin
            if (areg[i-1])
                yout_r <= yout_r + (breg << (i-1));
        end
        i <= (i == 16) ? 0 : i + 1;
        done <= (i == 16) ? 1 : 0;
    end else begin
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done <= 0;
    end
end

assign yout = yout_r;

endmodule