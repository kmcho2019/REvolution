module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
wire phase_a, phase_b;
reg phase_a_delayed;
wire phase_b_advanced;

// Counter logic with continuous assignment style
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        counter <= 3'b0;
    else
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
end

// Phase generation - now combinational
assign phase_a = (counter < 3'd4);
assign phase_b = (counter < 3'd3);

// Phase shifting - simplified
always @(negedge clk or negedge rst_n) begin
    if (!rst_n)
        phase_a_delayed <= 1'b0;
    else
        phase_a_delayed <= phase_a;
end

// Advanced phase sampled at negative edge
assign phase_b_advanced = phase_b;

// Phase combination remains combinational
assign clk_div = phase_a_delayed | phase_b_advanced;

endmodule