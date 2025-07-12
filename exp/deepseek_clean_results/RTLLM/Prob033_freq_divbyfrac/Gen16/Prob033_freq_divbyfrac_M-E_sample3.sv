module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [1:0] state;
reg toggle;
reg phase_toggle;
wire period_end;

// State machine tracks current period (3 or 4 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: state <= 2'b01;  // First cycle of 4-cycle period
            2'b01: state <= 2'b10;
            2'b10: state <= 2'b11;
            2'b11: state <= 2'b00; // Complete 4-cycle period
        endcase
    end
end

assign period_end = (state == 2'b11) || (state == 2'b10 && toggle);

// Main toggle flip-flop (4-cycle period)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        toggle <= 1'b0;
    end else if (period_end) begin
        toggle <= ~toggle;
    end
end

// Phase-shifted toggle (3-cycle period)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_toggle <= 1'b0;
    end else if (period_end) begin
        phase_toggle <= ~phase_toggle;
    end
end

// Final output combines both phases
assign clk_div = toggle ^ phase_toggle;

endmodule