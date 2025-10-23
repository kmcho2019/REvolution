module freq_divbyeven (
    input wire clk,
    input wire rst_n,        // Active low synchronous reset
    output reg clk_div      // Divided clock output
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

// Calculate required counter width
localparam COUNTER_WIDTH = $clog2(NUM_DIV/2);
localparam COUNT_MAX = (NUM_DIV/2) - 1;

// Down counter with synchronous reset
reg [COUNTER_WIDTH-1:0] cnt;
wire [COUNTER_WIDTH-1:0] next_cnt = 
    (!rst_n) ? COUNT_MAX :
    (cnt == 0) ? COUNT_MAX :
    cnt - 1;

// Toggle flip-flop
wire next_toggle = 
    (!rst_n) ? 1'b0 :
    (cnt == 0) ? ~clk_div :
    clk_div;

// Sequential logic
always @(posedge clk) begin
    cnt <= next_cnt;
    clk_div <= next_toggle;
end

endmodule