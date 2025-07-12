module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number
localparam DIV_HALF = NUM_DIV/2;
localparam GC_WIDTH = $clog2(DIV_HALF);

reg [GC_WIDTH-1:0] gray_cnt;
wire [GC_WIDTH-1:0] next_gray;
wire wrap_around;

// Gray code increment logic
assign next_gray = gray_cnt ^ ({1'b0, next_gray[GC_WIDTH-1:1]} + 1'b1);

// Wrap-around detection (when MSB toggles)
assign wrap_around = (gray_cnt[GC_WIDTH-1] ^ next_gray[GC_WIDTH-1]);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        gray_cnt <= {GC_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end else begin
        gray_cnt <= next_gray;
        if (wrap_around) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule