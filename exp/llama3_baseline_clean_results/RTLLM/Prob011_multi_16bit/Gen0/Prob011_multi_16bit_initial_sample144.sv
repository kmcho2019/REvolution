module multi_16bit (
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output reg [31:0] yout, 
    output reg done
);

reg [15:0] areg, breg;
reg [31:0] yout_r;
reg [4:0] i;
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        i <= 5'd0;
        done_r <= 1'b0;
    end else if (start) begin
        if (i == 5'd0) begin
            areg <= ain;
            breg <= bin;
        end
        if (i < 5'd17) begin
            i <= i + 1;
        end
        if (i > 5'd0 && i < 5'd17 && areg[15 - i + 1] == 1'b1) begin
            yout_r <= yout_r + (breg << (i - 1));
        end
    end else begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        i <= 5'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 1'b0;
    end else if (i == 5'd16) begin
        done_r <= 1'b1;
    end else if (i == 5'd17) begin
        done_r <= 1'b0;
    end
end

always @(posedge clk) begin
    yout <= yout_r;
    done <= done_r;
end

endmodule