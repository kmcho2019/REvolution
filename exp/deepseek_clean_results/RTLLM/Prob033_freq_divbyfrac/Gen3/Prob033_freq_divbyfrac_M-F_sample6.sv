module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// State counter for 7 cycles (3.5x division)
reg [2:0] count;

// Phase registers (generated on both edges)
reg phase_a;  // 4-clock period
reg phase_b;  // 3-clock period (180° offset)
reg phase_a_sync;
reg phase_b_sync;

// Reset and counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 3'd0;
        phase_a <= 1'b1;  // Start high
    end else begin
        if (count == 3'd6)  // 7 states (0-6)
            count <= 3'd0;
        else
            count <= count + 1;

        // Phase A transitions (4-clock period)
        case (count)
            3'd1: phase_a <= 1'b0;  // Fall after 2 clocks
            3'd3: phase_a <= 1'b1;  // Rise after 2 clocks
            default: phase_a <= phase_a;
        endcase
    end
end

// Phase B generation on negative edge (3-clock period)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;  // Start low
    end else begin
        // Phase B transitions (3-clock period with offset)
        case (count)
            3'd0: phase_b <= 1'b1;  // Rise at start
            3'd2: phase_b <= 1'b0;  // Fall after 1.5 clocks
            3'd3: phase_b <= 1'b1;  // Rise after 1.5 clocks
            3'd5: phase_b <= 1'b0;  // Fall after 1.5 clocks
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