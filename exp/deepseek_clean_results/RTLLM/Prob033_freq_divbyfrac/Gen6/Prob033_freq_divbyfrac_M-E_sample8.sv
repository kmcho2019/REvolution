module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Phase accumulator for 3.5x division (7 cycles total)
reg [2:0] phase_acc;
wire phase_rollover = (phase_acc == 3'd6);

// Clock generation registers
reg clk_a;
reg clk_b;

// Phase accumulator logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_acc <= 3'b0;
    end else begin
        phase_acc <= phase_rollover ? 3'b0 : phase_acc + 1'b1;
    end
end

// Clock A generation (4 cycles high, 3 cycles low)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
    end else begin
        case (phase_acc)
            3'd0, 3'd1, 3'd2, 3'd3: clk_a <= 1'b1;
            default: clk_a <= 1'b0;
        endcase
    end
end

// Clock B generation (shifted by half cycle)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_b <= 1'b0;
    end else begin
        case (phase_acc)
            3'd3, 3'd4, 3'd5, 3'd6: clk_b <= 1'b1;
            default: clk_b <= 1'b0;
        endcase
    end
end

// Final output combines both clocks
assign clk_div = clk_a | clk_b;

endmodule