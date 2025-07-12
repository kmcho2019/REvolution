module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

wire [2:0] counter;
reg [2:0] counter_reg;

// Counter implemented with continuous assignment
assign counter = (!rst_n) ? 3'b0 : 
                (counter_reg == 3'd6) ? 3'b0 : counter_reg + 1'b1;

always @(posedge clk) begin
    counter_reg <= counter;
end

// Phase generation with continuous assignments
wire clk_div1 = (counter < 3'd4) && rst_n;
wire clk_div2 = (counter > 3'd2) && rst_n;  // Adjusted for better phase alignment

// Combined output
assign clk_div = clk_div1 | clk_div2;

endmodule