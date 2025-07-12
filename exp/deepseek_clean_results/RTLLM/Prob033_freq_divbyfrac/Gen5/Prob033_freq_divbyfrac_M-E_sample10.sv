module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Phase accumulator for fractional division
reg [2:0] phase_acc;  // 3-bit accumulator (resolution = 1/8)
wire phase_overflow;

// Base 3x divider
reg [1:0] div_counter;
reg base_clk;

// Phase selection and edge generation
reg phase_sel;
reg delayed_clk;
reg steal_cycle;

// Phase accumulator update
assign phase_overflow = phase_acc[2];  // Overflow when MSB set

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_acc <= 3'b0;
    end else begin
        // Accumulate 4/7 (for 3.5x division)
        // 4/7 ≈ 0.571 → 0.571 * 8 = 4.568 → use 5/8 as approximation
        phase_acc <= phase_acc + 3'd5;
    end
end

// Base 3x divider
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        div_counter <= 2'b0;
        base_clk <= 1'b0;
    end else begin
        if (div_counter == 2'd2) begin
            div_counter <= 2'b0;
            base_clk <= ~base_clk;
        end else begin
            div_counter <= div_counter + 1'b1;
        end
    end
end

// Generate delayed version for phase selection
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        delayed_clk <= 1'b0;
    end else begin
        delayed_clk <= base_clk;
    end
end

// Cycle stealing logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        steal_cycle <= 1'b0;
        phase_sel <= 1'b0;
    end else begin
        steal_cycle <= phase_overflow;
        phase_sel <= phase_sel ^ phase_overflow;
    end
end

// Final output generation
always @(*) begin
    if (steal_cycle) begin
        // During stolen cycles, use phase-selected clock
        clk_div = phase_sel ? delayed_clk : base_clk;
    end else begin
        // Normal operation uses base clock
        clk_div = base_clk;
    end
end

endmodule