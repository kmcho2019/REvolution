module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a;
reg phase_b;

// 3-bit counter for 7 states (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'd0;
    end else begin
        counter <= (counter == 3'd6) ? 3'd0 : counter + 1;
    end
end

// Phase A (4-clock period: high for 2, low for 2)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        if (counter == 3'd0) phase_a <= 1'b1;
        else if (counter == 3'd2) phase_a <= 1'b0;
    end
end

// Phase B (3-clock period: high for 1.5, low for 1.5)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        if (counter == 3'd1) phase_b <= 1'b1;
        else if (counter == 3'd4) phase_b <= 1'b0;
    end
end

// Combine phases
assign clk_div = phase_a | phase_b;

endmodule