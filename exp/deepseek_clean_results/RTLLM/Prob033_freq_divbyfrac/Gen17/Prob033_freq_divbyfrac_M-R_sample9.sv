module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] cycle_counter;

// Main counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cycle_counter <= 3'b0;
    end else begin
        cycle_counter <= (cycle_counter == 3'd6) ? 3'b0 : cycle_counter + 1'b1;
    end
end

// Phase generation using direct assignments
wire phase_a = (cycle_counter < 3'd4);  // High for 4 cycles
wire phase_b = (cycle_counter >= 3'd4); // High for 3 cycles (inverted phase_a)

// Combine phases with proper edge alignment
assign clk_div = phase_a ^ phase_b;

endmodule