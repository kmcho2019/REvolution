module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6; // Must be even number (2, 4, 6, ...)

// Calculate required counter width (half of NUM_DIV)
localparam HALF_DIV = NUM_DIV / 2;
localparam COUNTER_WIDTH = $clog2(HALF_DIV);
reg [COUNTER_WIDTH-1:0] cnt;

always @(posedge clk) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 1'b0;
    end else begin
        if (cnt == HALF_DIV - 1) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule