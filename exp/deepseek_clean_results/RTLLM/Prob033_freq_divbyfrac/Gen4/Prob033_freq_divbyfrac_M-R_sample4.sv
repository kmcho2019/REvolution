module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// 3-bit counter for 7 states (0-6)
reg [2:0] counter;

// Phase registers
reg phase_a;
reg phase_b;

// Counter increment (modulo 7)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'd0;
    end else begin
        counter <= (counter == 3'd6) ? 3'd0 : counter + 1;
    end
end

// Phase A: high for 4 clocks (states 0-3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        phase_a <= (counter < 3'd4);
    end
end

// Phase B: high for 3 clocks (states 4-6) with negedge trigger
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        phase_b <= (counter >= 3'd4);
    end
end

// Combined output
assign clk_div = phase_a | phase_b;

endmodule