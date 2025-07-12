module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter PHASE_INC = 4;  // Phase increment value for 3.5x division

// Internal signals
reg [2:0] phase_acc;  // Phase accumulator
reg [2:0] threshold;  // Threshold value for phase comparator
reg phase_cmp;  // Output of phase comparator
reg clk_gen;  // Output of clock generator

// Initialize threshold value
initial threshold = 3'b100;

// Sequential logic for phase accumulator
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        phase_acc <= 3'b000;
    end else begin
        if (phase_acc == threshold) begin
            phase_acc <= 3'b000;
        end else begin
            phase_acc <= phase_acc + PHASE_INC;
        end
    end
end

// Combinational logic for phase comparator
assign phase_cmp = (phase_acc >= threshold) ? 1'b1 : 1'b0;

// Sequential logic for clock generator
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_gen <= 1'b0;
    end else begin
        if (phase_cmp) begin
            clk_gen <= ~clk_gen;
        end
    end
end

// Assign clock generator output to clk_div
assign clk_div = clk_gen;

endmodule