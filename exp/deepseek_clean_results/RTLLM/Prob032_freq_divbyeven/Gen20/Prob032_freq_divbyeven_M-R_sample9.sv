module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 6;  // Must be even number >= 2
localparam CNT_WIDTH = (NUM_DIV <= 2) ? 1 : $clog2(NUM_DIV);
localparam CNT_MAX = NUM_DIV - 1;

reg [CNT_WIDTH-1:0] cnt;

// Check parameter validity
initial begin
    if (NUM_DIV < 2 || NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be even and >= 2");
    end
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= {CNT_WIDTH{1'b0}};
    end else begin
        cnt <= (cnt == CNT_MAX) ? {CNT_WIDTH{1'b0}} : cnt + 1;
    end
end

// Output clock generation
assign clk_div = cnt < (NUM_DIV/2) ? 1'b0 : 1'b1;

endmodule