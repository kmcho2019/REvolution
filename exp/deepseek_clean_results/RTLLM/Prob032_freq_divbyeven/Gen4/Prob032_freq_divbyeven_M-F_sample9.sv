module freq_divbyeven (
    input wire clk,
    input wire rst_n,        // Synchronous reset (active low)
    output wire clk_div     // Glitch-free divided clock
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
localparam COUNT_INIT = (NUM_DIV/2) - 1;

wire [COUNTER_WIDTH-1:0] next_cnt;
wire next_div;
reg [COUNTER_WIDTH-1:0] cnt;
reg div_reg;

// Combinational counter and toggle logic
assign next_cnt = (!rst_n) ? COUNT_INIT :
                 (cnt == 0) ? COUNT_INIT : cnt - 1;

assign next_div = (!rst_n) ? 1'b0 :
                 (cnt == 0) ? ~div_reg : div_reg;

// Sequential logic
always @(posedge clk) begin
    cnt <= next_cnt;
    div_reg <= next_div;
end

// Registered output
assign clk_div = div_reg;

endmodule