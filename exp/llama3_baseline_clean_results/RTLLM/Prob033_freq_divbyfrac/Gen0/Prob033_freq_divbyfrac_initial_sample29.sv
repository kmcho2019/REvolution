module freq_divbyfrac(
    input           clk,         // Input clock signal
    input           rst_n,       // Active low reset signal
    output          clk_div      // Fractionally divided clock output
);

// Define parameters for the 3.5x division
localparam MUL2_DIV_CLK = 7;    // Total clock cycles for the division
localparam HIGH_PHASE_CLK = 4;  // Clock cycles for the high phase
localparam LOW_PHASE_CLK = 3;   // Clock cycles for the low phase

// Internal signals
reg [2:0]  cnt;                  // Counter to track clock cycles
reg        clk_int;             // Intermediate divided clock signal
reg        clk_phase1;           // First phase of the divided clock
reg        clk_phase2;           // Second phase of the divided clock
reg        clk_div_reg;         // Register for the final divided clock output

// Counter to generate the intermediate divided clock signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_int <= 1'b0;
    end else if (cnt == MUL2_DIV_CLK - 1) begin
        cnt <= 3'b000;
        clk_int <= ~clk_int;
    end else begin
        cnt <= cnt + 1'b1;
    end
end

// Generate the first phase of the divided clock (4 clock cycles high, 3 cycles low)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_phase1 <= 1'b0;
    end else if (cnt == HIGH_PHASE_CLK) begin
        clk_phase1 <= 1'b0;
    end else if (cnt == MUL2_DIV_CLK - 1) begin
        clk_phase1 <= 1'b1;
    end
end

// Generate the second phase of the divided clock (3 clock cycles high, 4 cycles low, phase-shifted)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_phase2 <= 1'b0;
    end else if (cnt == LOW_PHASE_CLK) begin
        clk_phase2 <= 1'b0;
    end else if (cnt == MUL2_DIV_CLK - 2) begin
        clk_phase2 <= 1'b1;
    end
end

// Final divided clock output is the logical OR of the two phases
assign clk_div = clk_phase1 | clk_phase2;

endmodule