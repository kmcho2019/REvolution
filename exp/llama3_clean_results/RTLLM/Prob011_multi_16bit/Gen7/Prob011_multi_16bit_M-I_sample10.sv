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
reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg done_r;
reg clock_enable;

// Pipeline stages for multiplication
reg [31:0] stage1;
reg [31:0] stage2;

always @(posedge clk) begin
    if (!rst_n) begin
        i <= 5'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
        clock_enable <= 1'b0;
        stage1 <= 32'd0;
        stage2 <= 32'd0;
    end else begin
        if (start && (i < 5'd17)) begin
            clock_enable <= 1'b1;
            if (i == 5'd0) begin
                areg <= ain;
                breg <= bin;
                yout_r <= 32'd0;
            end
            if (i == 5'd1) begin
                // First pipeline stage: Shift and accumulate
                stage1 <= (areg[0] == 1'b1) ? breg : 32'd0;
            end
            if (i > 5'd1 && i < 5'd17) begin
                // Subsequent pipeline stages: Accumulate shifted values
                if (i == 5'd2) begin
                    stage2 <= stage1 + ((areg[1] == 1'b1) ? (breg << 1) : 32'd0);
                end else begin
                    yout_r <= (i == 5'd16) ? (stage2 + ((areg[i-1] == 1'b1) ? (breg << (i-1)) : 32'd0)) : yout_r;
                end
            end
            i <= i + 1'b1;
            if (i == 5'd16) begin
                done_r <= 1'b1;
            end
        end else begin
            clock_enable <= 1'b0;
            if (!start || i >= 5'd17) begin
                i <= 5'd0;
                areg <= 16'd0;
                breg <= 16'd0;
                yout_r <= 32'd0;
                done_r <= 1'b0;
                stage1 <= 32'd0;
                stage2 <= 32'd0;
            end
        end
    end
    yout <= yout_r;
    done <= done_r;
end

endmodule