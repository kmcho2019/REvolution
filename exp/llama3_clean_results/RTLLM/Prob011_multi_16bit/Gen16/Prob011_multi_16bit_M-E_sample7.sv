module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [15:0] ain_reg;
reg [15:0] bin_reg;
reg [31:0] yout_reg;
reg [4:0] i;
reg done_reg;

assign yout = yout_reg;
assign done = done_reg;

always @(posedge clk) begin
    if (!rst_n) begin
        ain_reg <= 16'd0;
        bin_reg <= 16'd0;
        yout_reg <= 32'd0;
        i <= 5'd0;
        done_reg <= 1'b0;
    end else if (start && i == 5'd0) begin
        ain_reg <= ain;
        bin_reg <= bin;
        yout_reg <= 32'd0;
        i <= 5'd1;
    end else if (start && i < 5'd17) begin
        if (bin_reg[0] == 1'b1) begin
            yout_reg <= yout_reg + {16'd0, ain_reg};
        end
        bin_reg <= bin_reg >> 1;
        ain_reg <= {ain_reg[14:0], 1'b0};
        i <= i + 1'b1;
        if (i == 5'd16) begin
            done_reg <= 1'b1;
        end
    end else if (i == 5'd17) begin
        done_reg <= 1'b0;
        i <= 5'd0;
    end
end

endmodule