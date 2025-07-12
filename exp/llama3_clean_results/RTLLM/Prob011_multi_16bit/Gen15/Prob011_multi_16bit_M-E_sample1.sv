module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [15:0] ain_reg, bin_reg;
reg [31:0] partial_product, accumulated_product;
reg [4:0] i;
reg done_r;
reg [31:0] yout_r;

assign yout = yout_r;
assign done = done_r;

always @(posedge clk) begin
    if (!rst_n) begin
        ain_reg <= 16'd0;
        bin_reg <= 16'd0;
        partial_product <= 32'd0;
        accumulated_product <= 32'd0;
        i <= 5'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
    end else if (start) begin
        if (i == 5'd0) begin
            ain_reg <= ain;
            bin_reg <= bin;
            partial_product <= 32'd0;
            accumulated_product <= 32'd0;
        end
        if (i > 5'd0 && i < 5'd16) begin
            if (bin_reg[i-1] == 1'b1) begin
                partial_product <= ain_reg << (i-1);
            end else begin
                partial_product <= 32'd0;
            end
            accumulated_product <= accumulated_product + partial_product;
        end
        if (i == 5'd15) begin
            yout_r <= accumulated_product;
            done_r <= 1'b1;
        end
        i <= i + 1'b1;
    end else begin
        ain_reg <= 16'd0;
        bin_reg <= 16'd0;
        partial_product <= 32'd0;
        accumulated_product <= 32'd0;
        i <= 5'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
    end
end

endmodule