module freq_diveven (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

parameter NUM_DIV = 6; // Must be even number (2, 4, 6, ...)

// Calculate required counter width
localparam COUNTER_WIDTH = $clog2(NUM_DIV);
reg [COUNTER_WIDTH-1:0] cnt;

// Parameter validation during simulation
initial begin
    if (NUM_DIV % 2 != 0) begin
        $display("Error: NUM_DIV must be even, got %0d", NUM_DIV);
        $finish;
    end
end

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
    end else begin
        cnt <= (cnt == NUM_DIV - 1) ? 0 : cnt + 1;
    end
end

// Clock division - toggle when counter reaches half period
assign clk_div = (cnt < (NUM_DIV / 2)) ? 1'b0 : 1'b1;

endmodule