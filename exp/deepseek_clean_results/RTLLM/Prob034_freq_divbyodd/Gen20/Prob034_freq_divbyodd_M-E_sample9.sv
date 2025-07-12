module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Validate parameter
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

localparam DIV_HALF = (NUM_DIV - 1)/2;
reg [31:0] main_cnt;
reg [31:0] phase_cnt;
reg main_toggle;
reg phase_toggle;

// Dual-edge counter (counts on both edges)
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        main_cnt <= 0;
    end else begin
        main_cnt <= (main_cnt == NUM_DIV - 1) ? 0 : main_cnt + 1;
    end
end

// Phase-shifted version (delayed by half clock)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_cnt <= DIV_HALF;
        phase_toggle <= 0;
    end else begin
        phase_cnt <= (phase_cnt == NUM_DIV - 1) ? 0 : phase_cnt + 1;
        phase_toggle <= (phase_cnt >= DIV_HALF);
    end
end

// Main toggle generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        main_toggle <= 0;
    end else begin
        main_toggle <= (main_cnt >= DIV_HALF);
    end
end

// Final clock generation using XOR
assign clk_div = main_toggle ^ phase_toggle;

endmodule