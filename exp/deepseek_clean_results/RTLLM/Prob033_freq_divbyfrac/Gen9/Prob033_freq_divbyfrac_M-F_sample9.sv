module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a;
reg phase_b;

// 7-cycle counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Phase A generation (first 4 cycles, 50% duty)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a <= 1'b0;
    end else begin
        case (counter)
            3'd0, 3'd1: phase_a <= 1'b1;  // High for 2 cycles
            3'd2, 3'd3: phase_a <= 1'b0;  // Low for 2 cycles
            default: phase_a <= 1'b0;
        endcase
    end
end

// Phase B generation (next 3 cycles, 50% duty)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        case (counter)
            3'd4, 3'd5: phase_b <= 1'b1;  // High for 1.5 cycles
            3'd6:       phase_b <= 1'b0;  // Low for 1.5 cycles
            default:     phase_b <= 1'b0;
        endcase
    end
end

// Combine phases with OR as specified
assign clk_div = phase_a | phase_b;

endmodule