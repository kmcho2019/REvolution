module freq_divbyeven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)
localparam CNT_WIDTH = $clog2(NUM_DIV);

reg [CNT_WIDTH-1:0] cnt;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else begin
        cnt <= (cnt == NUM_DIV-1) ? 0 : cnt + 1;
    end
end

// Divided clock generation
assign clk_div = (cnt < NUM_DIV/2) ? 1'b0 : 1'b1;

endmodule