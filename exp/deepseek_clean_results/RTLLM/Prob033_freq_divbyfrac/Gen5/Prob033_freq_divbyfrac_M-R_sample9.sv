module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// 3-bit counter for 7 cycles (0-6)
reg [2:0] count;

// Counter logic (same as before)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 3'd0;
    end else begin
        count <= (count == 3'd6) ? 3'd0 : count + 1;
    end
end

// Phase generation using combinational logic
wire phase_a = (count < 3'd2) ? 1'b1 :  // First 2 clocks high
               (count < 3'd4) ? 1'b0 :  // Next 2 clocks low
               1'b1;                    // Repeat pattern

// Phase B uses negedge to create 180° offset
reg phase_b;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_b <= 1'b0;
    end else begin
        // Creates 3-clock period with 1.5 high, 1.5 low
        phase_b <= (count == 3'd0 || count == 3'd4) ? 1'b1 :
                  (count == 3'd3 || count == 3'd6) ? 1'b0 :
                  phase_b;
    end
end

// Combine phases (same as before)
assign clk_div = phase_a | phase_b;

endmodule