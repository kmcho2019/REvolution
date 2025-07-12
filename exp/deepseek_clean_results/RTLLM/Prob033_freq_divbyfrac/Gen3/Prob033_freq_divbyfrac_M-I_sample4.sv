module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// State counter (0-6 for 3.5x division)
reg [2:0] state;

// Phase registers
reg phase_a;
reg phase_b;
reg phase_a_sync;
reg phase_b_sync;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 3'd0;
    end else begin
        state <= (state == 3'd6) ? 3'd0 : state + 1;
    end
end

// Phase A generation (4-clock period)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        case (state)
            3'd0: phase_a <= 1'b1;  // Start high
            3'd2: phase_a <= 1'b0;  // After 2 clocks
            3'd4: phase_a <= 1'b1;  // Next high
            3'd6: phase_a <= 1'b0;  // Next low
            default: phase_a <= phase_a;
        endcase
    end
end

// Phase B generation (3-clock period, negative edge)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        case (state)
            3'd0: phase_b <= 1'b1;  // Start high
            3'd1: phase_b <= 1'b1;  // Remain high
            3'd3: phase_b <= 1'b0;  // After 1.5 clocks
            3'd4: phase_b <= 1'b0;  // Remain low
            3'd6: phase_b <= 1'b1;  // Next high
            default: phase_b <= phase_b;
        endcase
    end
end

// Synchronize phases to prevent glitches
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a_sync <= 1'b0;
        phase_b_sync <= 1'b0;
    end else begin
        phase_a_sync <= phase_a;
        phase_b_sync <= phase_b;
    end
end

// Combine phases to create final output
assign clk_div = phase_a_sync | phase_b_sync;

endmodule