module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// State encoding for 7-cycle period
reg [2:0] state;

// State transitions
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 3'b000;
    end else begin
        state <= (state == 3'b110) ? 3'b000 : state + 1;
    end
end

// Phase A clock (toggles every 3 or 4 cycles)
wire clk_a = (state < 3'b100);  // High for first 4 cycles

// Phase B clock (180° shifted version)
wire clk_b = (state < 3'b011 || state > 3'b101);  // High for different 4 cycles

// Combined output
assign clk_div = clk_a | clk_b;

endmodule