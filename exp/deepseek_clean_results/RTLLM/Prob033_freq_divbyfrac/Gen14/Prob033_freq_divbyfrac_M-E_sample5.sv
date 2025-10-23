module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] main_counter;
reg [2:0] phase_counter;
reg clk_0, clk_90;

// Main 7-state counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        main_counter <= 3'b0;
    end else begin
        main_counter <= (main_counter == 3'd6) ? 3'b0 : main_counter + 1;
    end
end

// Phase counter (90° offset)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_counter <= 3'd2; // Initial 90° offset
    end else begin
        phase_counter <= (phase_counter == 3'd6) ? 3'b0 : phase_counter + 1;
    end
end

// Primary clock (0° phase)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_0 <= 1'b0;
    end else begin
        clk_0 <= (main_counter < 3'd3) ? 1'b1 :  // 3 cycles high
                (main_counter < 3'd7) ? 1'b0 :  // 4 cycles low
                1'b0;
    end
end

// Quadrature clock (90° phase)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_90 <= 1'b0;
    end else begin
        clk_90 <= (phase_counter < 3'd3) ? 1'b1 :  // 3 cycles high
                 (phase_counter < 3'd7) ? 1'b0 :  // 4 cycles low
                 1'b0;
    end
end

// Combined output using XOR for clean transitions
assign clk_div = clk_0 ^ clk_90;

endmodule