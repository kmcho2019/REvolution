module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

wire [2:0] counter_next;
reg [2:0] counter;
reg phase_a, phase_b;

// Counter logic (combinational)
assign counter_next = (!rst_n) ? 3'b0 : 
                     (counter == 3'd6) ? 3'b0 : counter + 1'b1;

// Positive edge phase_a generation
always @(posedge clk) begin
    counter <= counter_next;
    phase_a <= (counter_next < 3'd4);
end

// Negative edge phase_b generation (180° shifted)
always @(negedge clk) begin
    phase_b <= (counter_next > 3'd2) && (counter_next < 3'd6);
end

// Combine phases with OR for final output
assign clk_div = phase_a | phase_b;

endmodule