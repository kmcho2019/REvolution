module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a;
reg phase_b;

// Main counter (0-6) for 3.5x division
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Phase A generation (4-clock cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        case (counter)
            3'd0: phase_a <= 1'b1;
            3'd4: phase_a <= 1'b0;
            default: phase_a <= phase_a;
        endcase
    end
end

// Phase B generation (3-clock cycles) - uses falling edge
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        case (counter)
            3'd3: phase_b <= 1'b1;
            3'd6: phase_b <= 1'b0;
            default: phase_b <= phase_b;
        endcase
    end
end

// Final output combination
assign clk_div = phase_a | phase_b;

endmodule