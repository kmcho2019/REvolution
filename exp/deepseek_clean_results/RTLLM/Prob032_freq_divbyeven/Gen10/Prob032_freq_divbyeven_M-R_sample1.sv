module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)
localparam DIV_HALF = NUM_DIV/2;

reg [3:0] cnt;
wire [3:0] next_cnt;

// Combinational counter logic
assign next_cnt = (!rst_n) ? 0 : 
                 (cnt == DIV_HALF - 1) ? 0 : cnt + 1;

// Divided clock generation
assign clk_div = (cnt >= DIV_HALF/2) && rst_n;

// Sequential counter update
always @(posedge clk) begin
    cnt <= next_cnt;
end

endmodule