module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// 7-state counter for 3.5x division
reg [2:0] cnt;

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b0;
    end else begin
        cnt <= (cnt == 3'd6) ? 3'b0 : cnt + 1'b1;
    end
end

// Phase generation (combinational)
wire phase0 = (cnt < 3'd4);  // High for counts 0-3 (4 cycles)
wire phase180 = (cnt > 3'd2); // High for counts 3-6 (4 cycles)

// Final output combines both phases
assign clk_div = phase0 | phase180;

endmodule