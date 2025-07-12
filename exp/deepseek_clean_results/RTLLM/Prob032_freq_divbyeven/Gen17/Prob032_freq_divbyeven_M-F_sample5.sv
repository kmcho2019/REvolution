module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number
// Uncomment for synthesis check:
// initial if (NUM_DIV % 2 != 0) $error("NUM_DIV must be even");
localparam CNT_LIMIT = NUM_DIV - 1;
localparam TOGGLE_POINT = (NUM_DIV/2) - 1;
localparam CNT_WIDTH = $clog2(NUM_DIV);

reg [CNT_WIDTH-1:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else begin
        if (cnt == CNT_LIMIT) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
        
        if (cnt == TOGGLE_POINT) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule