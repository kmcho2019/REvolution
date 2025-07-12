module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameters for 3.5x division (7 cycles total)
localparam DIV_HIGH = 4;  // 4 cycles high
localparam DIV_LOW  = 3;  // 3 cycles low
localparam DIV_TOTAL = DIV_HIGH + DIV_LOW;

// Unified counter using both clock edges
reg [2:0] cnt;
reg cnt_dir;  // 0=counting up, 1=counting down
wire cnt_max = (cnt == DIV_TOTAL-1);
wire cnt_min = (cnt == 0);

// Clock generation registers
reg clk_0;
reg clk_180;

// Main counter (uses both edges for precise control)
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b0;
        cnt_dir <= 1'b0;
    end else begin
        if (posedge clk) begin
            if (cnt_dir) begin
                cnt <= cnt_min ? 3'b0 : cnt - 1'b1;
            end else begin
                cnt <= cnt_max ? DIV_TOTAL-1 : cnt + 1'b1;
            end
            cnt_dir <= cnt_max ? 1'b1 : (cnt_min ? 1'b0 : cnt_dir);
        end
    end
end

// 0° phase clock generation (posedge)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_0 <= 1'b0;
    end else begin
        clk_0 <= (cnt < DIV_HIGH) ? 1'b1 : 1'b0;
    end
end

// 180° phase clock generation (negedge)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_180 <= 1'b0;
    end else begin
        clk_180 <= (cnt < DIV_HIGH) ? 1'b1 : 1'b0;
    end
end

// Glitch-free output combination
assign clk_div = clk_0 | clk_180;

endmodule