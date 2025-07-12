module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Parameters for 3.5 division (7/2)
parameter PHASE_ACC_WIDTH = 3;
parameter DIV_RATIO = 7;

reg [PHASE_ACC_WIDTH-1:0] phase_acc;
reg [2:0] counter_a, counter_b;
reg clk_a, clk_b;
reg phase_sel;

// Phase accumulator for fractional timing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_acc <= 0;
    end else begin
        phase_acc <= phase_acc + 2; // Accumulate 2/7 each cycle
    end
end

// Counter A (4 cycles high)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter_a <= 0;
        clk_a <= 0;
    end else begin
        if (counter_a == DIV_RATIO-1) begin
            counter_a <= 0;
            clk_a <= 1;
        end else if (counter_a == 3) begin
            clk_a <= 0;
            counter_a <= counter_a + 1;
        end else begin
            counter_a <= counter_a + 1;
        end
    end
end

// Counter B (3 cycles high, phase shifted)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter_b <= 2; // Initial phase offset
        clk_b <= 0;
    end else begin
        if (counter_b == DIV_RATIO-1) begin
            counter_b <= 0;
            clk_b <= 1;
        end else if (counter_b == 2) begin
            clk_b <= 0;
            counter_b <= counter_b + 1;
        end else begin
            counter_b <= counter_b + 1;
        end
    end
end

// Phase selection based on accumulator
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_sel <= 0;
    end else begin
        phase_sel <= phase_acc[PHASE_ACC_WIDTH-1];
    end
end

// Glitch-free output multiplexer
assign clk_div = (phase_sel) ? clk_b : clk_a;

endmodule