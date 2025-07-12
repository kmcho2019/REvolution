module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [3:0] phase_acc;
wire phase_overflow;
reg main_phase;
reg interp_phase;

// Phase accumulator adds 2 each cycle (for 3.5x division)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_acc <= 4'b0;
    end else begin
        phase_acc <= phase_acc + 4'd2;
    end
end

assign phase_overflow = phase_acc[3];  // Overflow at 8 (half of 16)

// Main phase (handles whole cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        main_phase <= 1'b0;
    end else begin
        main_phase <= (phase_acc < 4'd8) ? 1'b1 : 1'b0;
    end
end

// Interpolated phase (handles half-cycle shifts)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        interp_phase <= 1'b0;
    end else begin
        interp_phase <= ((phase_acc - 4'd8) < 4'd8) ? 1'b1 : 1'b0;
    end
end

// Combined output
assign clk_div = main_phase | interp_phase;

endmodule