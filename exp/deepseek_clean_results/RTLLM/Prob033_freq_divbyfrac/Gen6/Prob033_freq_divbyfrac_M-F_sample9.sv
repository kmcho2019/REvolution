module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase_a, phase_b;
reg phase_a_delayed;

// Counter (0-6) on positive edge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Phase A generation (4 high, 3 low)
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

// Phase B generation (3 high, 4 low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        case (counter)
            3'd0: phase_b <= 1'b1;
            3'd3: phase_b <= 1'b0;
            default: phase_b <= phase_b;
        endcase
    end
end

// Half-cycle delay for phase_a (using negative edge)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_a_delayed <= 1'b0;
    end else begin
        phase_a_delayed <= phase_a;
    end
end

// Combine phases with OR
assign clk_div = (phase_a | phase_b) & (phase_a_delayed | phase_b);

endmodule