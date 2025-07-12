module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// 3-bit counter for 7-cycle period (0-6)
reg [2:0] main_counter;

// Phase rotation counter (0-3)
reg [1:0] phase_rotator;

// Clock generation registers
reg base_div;
reg delayed_div;
reg phase_a;
reg phase_b;

// Main 7-cycle counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        main_counter <= 3'b0;
    end else begin
        main_counter <= (main_counter == 3'd6) ? 3'b0 : main_counter + 1'b1;
    end
end

// Phase rotator advances every full cycle
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_rotator <= 2'b0;
    end else if (main_counter == 3'd6) begin
        phase_rotator <= phase_rotator + 1'b1;
    end
end

// Base divided clock (alternates between 3 and 4 cycles high)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        base_div <= 1'b0;
    end else begin
        case (phase_rotator)
            2'b00: base_div <= (main_counter < 3'd4);  // 4 cycles high
            2'b01: base_div <= (main_counter < 3'd3);  // 3 cycles high
            2'b10: base_div <= (main_counter < 3'd4);  // 4 cycles high
            2'b11: base_div <= (main_counter < 3'd3);  // 3 cycles high
        endcase
    end
end

// Create delayed version on negative edge
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        delayed_div <= 1'b0;
    end else begin
        delayed_div <= base_div;
    end
end

// Phase A (original) and Phase B (delayed + phase shifted)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
        phase_b <= 1'b0;
    end else begin
        phase_a <= base_div;
        phase_b <= delayed_div & (phase_rotator[0] ^ phase_rotator[1]);
    end
end

// Final output combines both phases
assign clk_div = phase_a | phase_b;

endmodule