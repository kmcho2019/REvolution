module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Division parameters
localparam PERIOD_A = 4;  // 4 cycles
localparam PERIOD_B = 3;  // 3 cycles

reg [2:0] counter;
reg phase_0;
reg phase_180;
wire clk_phase_0;
wire clk_phase_180;

// Main counter and phase generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        phase_0 <= 1'b1;
        phase_180 <= 1'b0;
    end else begin
        // Counter wraps at 6 (for alternating 3/4 cycles)
        if (counter == 3'd6) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end

        // Generate two phase-shifted clocks
        case (counter)
            0: begin phase_0 <= 1'b1; phase_180 <= 1'b0; end
            1: begin phase_180 <= 1'b1; end
            2: begin phase_0 <= 1'b0; end
            3: begin phase_180 <= 1'b0; end
            4: begin phase_0 <= 1'b1; end
            5: begin phase_180 <= 1'b1; end
            6: begin phase_0 <= 1'b0; phase_180 <= 1'b0; end
        endcase
    end
end

// Clock phase outputs (registered for clean edges)
assign clk_phase_0 = phase_0;
assign clk_phase_180 = phase_180;

// Final output combines both phases
assign clk_div = clk_phase_0 | clk_phase_180;

endmodule