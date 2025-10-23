module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;

// 7-state counter (0-6) for 3.5x division
always @(posedge clk) begin
    if (!rst_n) begin
        counter <= 3'd0;
    end else begin
        counter <= (counter == 3'd6) ? 3'd0 : counter + 1;
    end
end

// Generate phase A (4-clock high, 3-clock low)
always @(posedge clk) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        // High for counter values 0-3 (4 cycles)
        phase_a <= (counter < 3'd4);
    end
end

// Generate phase B (same pattern but offset by 3.5 cycles)
always @(posedge clk) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        // Offset by 3 or 4 depending on counter value
        // This creates the 3.5 cycle phase shift
        case (counter)
            3'd0: phase_b <= 1'b0;
            3'd1: phase_b <= 1'b0;
            3'd2: phase_b <= 1'b0;
            3'd3: phase_b <= 1'b1;
            3'd4: phase_b <= 1'b1;
            3'd5: phase_b <= 1'b1;
            3'd6: phase_b <= 1'b0;
            default: phase_b <= 1'b0;
        endcase
    end
end

// Combine phases to create final output
always @(posedge clk) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= phase_a | phase_b;
    end
end

endmodule