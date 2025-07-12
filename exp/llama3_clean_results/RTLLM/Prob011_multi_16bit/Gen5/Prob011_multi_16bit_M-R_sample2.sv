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
reg start_r;
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 0;
        start_r <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end else begin
        start_r <= start;
        if (start_r) begin
            if (i < 16) begin
                i <= i + 1;
            end else begin
                i <= 0;
            end
        end else begin
            i <= 0;
        end
        if (i == 0) begin
            areg <= ain;
            breg <= bin;
            yout_r <= 0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        done_r <= 0;
    end else begin
        if (i == 16) begin
            done_r <= 1;
        end else begin
            done_r <= 0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        yout <= 0;
    end else begin
        if (i > 0 && i < 17) begin
            if (areg[i-1]) begin
                yout <= yout_r + (breg << (i-1));
            end else begin
                yout <= yout_r;
            end
        end else begin
            yout <= yout_r;
        end
    end
end

assign done = done_r;

endmodule