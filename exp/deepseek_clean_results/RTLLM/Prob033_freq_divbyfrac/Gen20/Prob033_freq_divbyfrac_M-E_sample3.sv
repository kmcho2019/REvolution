module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Phase accumulator for fractional control
reg [2:0] phase_acc;
wire phase_overflow = phase_acc[2];
reg div_sel;  // Selects between 3 and 4 cycles

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_acc <= 3'b0;
        div_sel <= 1'b0;
    end else begin
        phase_acc <= phase_acc + 3'd2;  // Increment by 2 (for 3.5x)
        if (phase_overflow) begin
            div_sel <= ~div_sel;  // Toggle divider selection
        end
    end
end

// Dual divider implementation
reg [1:0] div3_cnt;
reg [2:0] div4_cnt;
reg div3_out, div4_out;

// Divide-by-3 counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        div3_cnt <= 2'b0;
        div3_out <= 1'b0;
    end else if (div_sel) begin
        div3_cnt <= (div3_cnt == 2'd2) ? 2'b0 : div3_cnt + 1'b1;
        div3_out <= (div3_cnt < 2'd1);  // 66% duty cycle
    end else begin
        div3_out <= 1'b0;
    end
end

// Divide-by-4 counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        div4_cnt <= 3'b0;
        div4_out <= 1'b0;
    end else if (!div_sel) begin
        div4_cnt <= (div4_cnt == 3'd3) ? 3'b0 : div4_cnt + 1'b1;
        div4_out <= (div4_cnt < 3'd2);  // 50% duty cycle
    end else begin
        div4_out <= 1'b0;
    end
end

// Phase-aligned output combination
reg div3_delayed;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        div3_delayed <= 1'b0;
    end else begin
        div3_delayed <= div3_out;
    end
end

// Final output combines both dividers with proper phase
assign clk_div = (div_sel ? div3_delayed : div4_out) | 
                 (div_sel ? div3_out : div4_out);

endmodule