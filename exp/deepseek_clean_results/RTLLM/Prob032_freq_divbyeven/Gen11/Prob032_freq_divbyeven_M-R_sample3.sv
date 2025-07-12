module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 4; // Must be even number (2, 4, 6, ...)

// Calculate required counter width and limit
localparam COUNTER_WIDTH = $clog2(NUM_DIV);
localparam COUNT_LIMIT = NUM_DIV - 1;

reg [COUNTER_WIDTH-1:0] cnt;

// Parameter validation during simulation
initial begin
    if (NUM_DIV % 2 != 0) begin
        $display("Error: NUM_DIV must be even, got %0d", NUM_DIV);
        $finish;
    end
end

// Counter logic only
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else begin
        cnt <= (cnt == COUNT_LIMIT) ? 0 : cnt + 1;
    end
end

// Clock division is simply MSB of counter (implicit toggle)
assign clk_div = cnt[COUNTER_WIDTH-1];

endmodule