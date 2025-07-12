module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [2:0] cnt;          // Main counter (0-6)
reg phase_toggle;       // Toggles between long/short periods
reg clk_a, clk_b;       // Phase-shifted intermediate clocks

// Main counter with alternating period lengths
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b0;
        phase_toggle <= 1'b0;
    end else begin
        if (cnt == (phase_toggle ? 3'd2 : 3'd3)) begin
            cnt <= 3'b0;
            phase_toggle <= ~phase_toggle;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

// Generate phase A (posedge triggered)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
    end else begin
        clk_a <= (cnt == 3'b0) ? 1'b1 : 
                ((cnt == (phase_toggle ? 3'd2 : 3'd3)) ? 1'b0 : clk_a);
    end
end

// Generate phase B (negedge triggered, 180° shifted)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_b <= 1'b0;
    end else begin
        clk_b <= (cnt == 3'b0) ? 1'b1 : 
                ((cnt == (phase_toggle ? 3'd2 : 3'd3)) ? 1'b0 : clk_b);
    end
end

// Combine phases with output register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_a | clk_b;
    end
end

endmodule