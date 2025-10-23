module freq_divbyfrac (
    input clk,
    input rst_n,
    output clk_div
);

// Counter for 4-cycle period (0-3)
reg [1:0] cnt4;
// Counter for 3-cycle period (0-2)
reg [1:0] cnt3;

// Clock signals
reg clk4, clk3;
// Phase-shifted versions
reg clk4_shift, clk3_shift;

// 4-cycle counter (0-3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt4 <= 2'd0;
    else
        cnt4 <= (cnt4 == 2'd3) ? 2'd0 : cnt4 + 1;
end

// 3-cycle counter (0-2)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt3 <= 2'd0;
    else
        cnt3 <= (cnt3 == 2'd2) ? 2'd0 : cnt3 + 1;
end

// Generate clk4 (4-cycle period, 50% duty)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        clk4 <= 1'b0;
    else if (cnt4 == 2'd0)
        clk4 <= 1'b1;
    else if (cnt4 == 2'd2)
        clk4 <= 1'b0;
end

// Generate clk3 (3-cycle period, 50% duty)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        clk3 <= 1'b0;
    else if (cnt3 == 2'd0)
        clk3 <= 1'b1;
    else if (cnt3 == 2'd1)
        clk3 <= 1'b0;
end

// Create phase-shifted versions using negedge
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk4_shift <= 1'b0;
        clk3_shift <= 1'b0;
    end else begin
        clk4_shift <= clk4;
        clk3_shift <= clk3;
    end
end

// Combine clocks with proper phase alignment
assign clk_div = (clk4 & ~clk4_shift) | (clk3 & ~clk3_shift);

endmodule