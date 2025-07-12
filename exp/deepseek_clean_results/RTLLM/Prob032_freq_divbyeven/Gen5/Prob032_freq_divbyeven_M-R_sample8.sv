module freq_diveven (
    input wire clk,
    input wire rst_n,        // Synchronous reset (active low)
    output wire clk_div     // Divided clock output
);

// Division factor must be even and >= 2
parameter NUM_DIV = 4;

// Validate parameter at elaboration
initial begin
    if (NUM_DIV < 2 || NUM_DIV[0] != 0) begin
        $error("NUM_DIV must be even and >= 2. Current value: %0d", NUM_DIV);
        $finish;
    end
end

// Calculate required counter width (log2(NUM_DIV/2))
localparam COUNTER_WIDTH = $clog2(NUM_DIV/2);
localparam COUNT_MAX = (NUM_DIV/2) - 1;

reg [COUNTER_WIDTH-1:0] cnt;
reg toggle;

// Counter logic - counts down from COUNT_MAX to 0
wire [COUNTER_WIDTH-1:0] next_cnt = 
    (!rst_n) ? COUNT_MAX :
    (cnt == 0) ? COUNT_MAX :
    cnt - 1;

// Toggle flip-flop
wire next_toggle = 
    (!rst_n) ? 1'b0 :
    (cnt == 0) ? ~toggle :
    toggle;

// Update registers on clock edge
always @(posedge clk) begin
    cnt <= next_cnt;
    toggle <= next_toggle;
end

// Output assignment
assign clk_div = toggle;

endmodule