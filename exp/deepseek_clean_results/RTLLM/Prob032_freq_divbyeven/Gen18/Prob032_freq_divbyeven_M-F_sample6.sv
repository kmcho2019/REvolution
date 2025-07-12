module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number >= 2
localparam DIV_HALF = NUM_DIV/2;
localparam CNT_WIDTH = (NUM_DIV <= 2) ? 1 : $clog2(DIV_HALF);
localparam CNT_MAX = DIV_HALF - 1;

reg [CNT_WIDTH-1:0] cnt;

// Check parameter validity
initial begin
    if (NUM_DIV < 2 || NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be even and >= 2");
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end else begin
        if (cnt == CNT_MAX) begin
            cnt <= {CNT_WIDTH{1'b0}};
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule