module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;

// Counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        counter <= 3'b0;
    else
        counter <= (counter == 6) ? 3'b0 : counter + 1;
end

// Main phase (4 cycles high)
wire clk_main = (counter < 4);

// Shifted phase (3 cycles high, half-cycle delayed)
reg clk_shifted;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n)
        clk_shifted <= 1'b0;
    else
        clk_shifted <= (counter >= 4);
end

// Combined output
assign clk_div = clk_main | clk_shifted;

endmodule