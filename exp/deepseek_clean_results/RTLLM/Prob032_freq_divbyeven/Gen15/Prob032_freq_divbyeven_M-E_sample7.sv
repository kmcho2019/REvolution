module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number
localparam DIV_HALF = NUM_DIV/2;
localparam CNT_WIDTH = $clog2(DIV_HALF);

reg [CNT_WIDTH-1:0] binary_cnt;
wire [CNT_WIDTH-1:0] gray_cnt;

// Binary to Gray code conversion
assign gray_cnt = binary_cnt ^ (binary_cnt >> 1);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        binary_cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end else begin
        if (binary_cnt == DIV_HALF-1) begin
            binary_cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end else begin
            binary_cnt <= binary_cnt + 1;
        end
    end
end

endmodule