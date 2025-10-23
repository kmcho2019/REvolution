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
reg [4:0] i;
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'b0;
        areg <= 16'b0;
        breg <= 16'b0;
        yout_r <= 32'b0;
        done_r <= 1'b0;
    end else if (start) begin
        if (i == 5'b0) begin
            areg <= ain;
            breg <= bin;
            yout_r <= 32'b0;
        end else if (i < 5'd16) begin
            if (areg[i-1] == 1'b1) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end
        if (i < 5'd17) begin
            i <= i + 1;
        end else begin
            i <= 5'b0;
        end
        if (i == 5'd16) begin
            done_r <= 1'b1;
        end else if (i == 5'd17) begin
            done_r <= 1'b0;
        end
    end else begin
        i <= 5'b0;
        yout_r <= 32'b0;
        done_r <= 1'b0;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule