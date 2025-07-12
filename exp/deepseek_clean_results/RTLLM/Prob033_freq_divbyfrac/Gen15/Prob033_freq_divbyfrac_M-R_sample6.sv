module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

wire [2:0] counter_next = (!rst_n) ? 3'b0 : 
                         (counter == 3'd6) ? 3'b0 : counter + 1;
reg [2:0] counter;

// Main counter (posedge)
always @(posedge clk) begin
    counter <= counter_next;
end

// Base clock generation (combinational)
wire base_clk = (counter < 3'd4) & rst_n;

// Phase-shifted clock (negedge)
reg phase_shift_clk;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        phase_shift_clk <= 1'b0;
    end else begin
        phase_shift_clk <= base_clk;
    end
end

// Combined output
assign clk_div = base_clk | phase_shift_clk;

endmodule