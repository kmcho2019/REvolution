module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg [1:0] phase_acc;
reg clk_a, clk_b;
reg period_sel;  // 0=4-cycle, 1=3-cycle

// Phase accumulator for fractional timing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_acc <= 2'b0;
        period_sel <= 1'b0;
    end else begin
        phase_acc <= phase_acc + 2'b1;
        if (phase_acc == 2'b1) begin
            period_sel <= ~period_sel;
        end
    end
end

// Dynamic period counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        if (period_sel) begin
            counter <= (counter == 2) ? 3'b0 : counter + 1;
        end else begin
            counter <= (counter == 3) ? 3'b0 : counter + 1;
        end
    end
end

// Phase A clock (0°)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
    end else begin
        if (period_sel) begin
            clk_a <= (counter < 2);
        end else begin
            clk_a <= (counter < 2);
        end
    end
end

// Phase B clock (90° shifted)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_b <= 1'b0;
    end else begin
        if (period_sel) begin
            clk_b <= (counter < 2);
        end else begin
            clk_b <= (counter < 2);
        end
    end
end

// Combined output with precise edge alignment
assign clk_div = (clk_a | clk_b) & 
                ((period_sel && (counter != 2)) || 
                (!period_sel && (counter != 3)));

endmodule