module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] cnt;          // 0-6 counter for 3.5x division
reg phase_toggle;       // Toggles between 4 and 3 cycle periods
reg clk_a, clk_b;       // Phase-shifted intermediate clocks

// Main counter with alternating 4/3 cycle periods
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b0;
        phase_toggle <= 1'b0;
    end else begin
        if ((!phase_toggle && cnt == 3'd3) || (phase_toggle && cnt == 3'd2)) begin
            cnt <= 3'b0;
            phase_toggle <= ~phase_toggle;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

// Generate phase A (posedge triggered, 4/3 cycle pattern)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
    end else begin
        if (cnt == 3'b0)
            clk_a <= 1'b1;
        else if ((!phase_toggle && cnt == 3'd3) || (phase_toggle && cnt == 3'd2))
            clk_a <= 1'b0;
    end
end

// Generate phase B (negedge triggered, half-cycle shifted)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_b <= 1'b0;
    end else begin
        if (cnt == 3'b0)
            clk_b <= 1'b1;
        else if ((!phase_toggle && cnt == 3'd3) || (phase_toggle && cnt == 3'd2))
            clk_b <= 1'b0;
    end
end

// Combine phases with combinational logic
assign clk_div = clk_a | clk_b;

endmodule