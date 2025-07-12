module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;

// Counter and phase generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        phase_a <= 1'b0;
        phase_b <= 1'b0;
    end
    else begin
        // Update counter (0-6)
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
        
        // Generate phase A (high for 0-3)
        phase_a <= (counter <= 3'd3);
        
        // Generate phase B (high for 4-6)
        phase_b <= (counter >= 3'd4);
    end
end

// Half-cycle delayed version of phase A
reg phase_a_delayed;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n)
        phase_a_delayed <= 1'b0;
    else
        phase_a_delayed <= phase_a;
end

// Final output combines both phases
assign clk_div = phase_a_delayed | phase_b;

endmodule