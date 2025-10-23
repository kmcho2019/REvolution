module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [31:0] seg_mult1, seg_mult2, seg_mult3, seg_mult4;
reg [31:0] accum_stage1, accum_stage2, accum_stage3;
reg [4:0] i;
reg done_r;

always @(posedge clk) begin
    if (!rst_n) begin
        seg_mult1 <= 32'd0;
        seg_mult2 <= 32'd0;
        seg_mult3 <= 32'd0;
        seg_mult4 <= 32'd0;
        accum_stage1 <= 32'd0;
        accum_stage2 <= 32'd0;
        accum_stage3 <= 32'd0;
        i <= 5'd0;
        done_r <= 1'b0;
    end else begin
        if (start) begin
            // Segment multipliers
            seg_mult1 <= ain[3:0] * bin[3:0];
            seg_mult2 <= ain[7:4] * bin[3:0];
            seg_mult3 <= ain[11:8] * bin[3:0];
            seg_mult4 <= ain[15:12] * bin[3:0];

            // Accumulation stages
            if (i == 5'd0) begin
                accum_stage1 <= seg_mult1;
            end else if (i == 5'd1) begin
                accum_stage2 <= accum_stage1 + (seg_mult2 << 4);
            end else if (i == 5'd2) begin
                accum_stage3 <= accum_stage2 + (seg_mult3 << 8);
            end else if (i == 5'd3) begin
                yout <= accum_stage3 + (seg_mult4 << 12);
                done_r <= 1'b1;
            end

            // Increment counter
            i <= i + 1'b1;

            // Reset counter and done flag when finished
            if (i == 5'd4) begin
                i <= 5'd0;
                done_r <= 1'b0;
            end
        end
    end
end

assign yout = yout;
assign done = done_r;

endmodule