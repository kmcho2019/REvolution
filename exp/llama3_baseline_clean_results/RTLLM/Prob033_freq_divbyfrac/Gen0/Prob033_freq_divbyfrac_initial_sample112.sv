module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define the multiplication factor for the fractional division (3.5x)
localparam MUL2_DIV_CLK = 7;
localparam DIV_CLK_CYCLES_A = 4; // 4 source clock cycles
localparam DIV_CLK_CYCLES_B = 3; // 3 source clock cycles

// Counter to cycle through the divided clock cycles
reg [2:0] cnt_div;
reg [2:0] next_cnt_div;

// Counter to keep track of the current divided clock cycle
reg phase_a, phase_b;
reg next_phase_a, next_phase_b;

// D flip-flops to generate the phase-shifted clocks
reg clk_phase_a, clk_phase_b;
reg next_clk_phase_a, next_clk_phase_b;

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_div <= 3'b000;
        phase_a <= 1'b0;
        phase_b <= 1'b0;
        clk_phase_a <= 1'b0;
        clk_phase_b <= 1'b0;
    end else begin
        cnt_div <= next_cnt_div;
        phase_a <= next_phase_a;
        phase_b <= next_phase_b;
        clk_phase_a <= next_clk_phase_a;
        clk_phase_b <= next_clk_phase_b;
    end
end

// Combinational logic
always @(*) begin
    next_cnt_div = cnt_div;
    next_phase_a = phase_a;
    next_phase_b = phase_b;
    next_clk_phase_a = clk_phase_a;
    next_clk_phase_b = clk_phase_b;

    if (cnt_div == MUL2_DIV_CLK - 1) begin
        next_cnt_div = 3'b000;
    end else begin
        next_cnt_div = cnt_div + 1'b1;
    end

    if (cnt_div == DIV_CLK_CYCLES_A - 1) begin
        next_phase_a = ~phase_a;
    end

    if (cnt_div == (MUL2_DIV_CLK - DIV_CLK_CYCLES_B) - 1) begin
        next_phase_b = ~phase_b;
    end

    // Generate phase-shifted clocks
    if (phase_a) begin
        next_clk_phase_a = ~clk_phase_a;
    end

    if (phase_b) begin
        next_clk_phase_b = ~clk_phase_b;
    end
end

// Generate the final fractional divided clock output
assign clk_div = (clk_phase_a || clk_phase_b);

endmodule