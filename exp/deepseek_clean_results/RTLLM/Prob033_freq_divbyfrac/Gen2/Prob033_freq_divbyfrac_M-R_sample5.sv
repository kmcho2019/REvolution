module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
wire clk_div1, clk_div2;

// 7-cycle counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// First divided clock (toggles at 3.5 cycle intervals)
assign clk_div1 = counter[2] ^ counter[0];  // Adds correction for fractional division

// Second divided clock (180° phase shifted version)
assign clk_div2 = ~(counter[2] ^ counter[0]);

// Combine both phases to create final output
assign clk_div = clk_div1 | clk_div2;

endmodule