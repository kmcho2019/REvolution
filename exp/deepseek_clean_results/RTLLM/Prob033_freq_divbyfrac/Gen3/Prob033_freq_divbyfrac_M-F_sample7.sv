module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Internal signals
reg [2:0] counter;
reg clk_pos, clk_neg;

// Main counter and positive phase clock
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        clk_pos <= 1'b0;
    end else begin
        counter <= (counter == 6) ? 3'b0 : counter + 1;
        // clk_pos high for 4 cycles (0-3)
        clk_pos <= (counter < 4);
    end
end

// Negative phase clock (half-cycle delayed)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_neg <= 1'b0;
    end else begin
        // clk_neg high for 3 cycles (0-2) but phase shifted
        clk_neg <= (counter < 3);
    end
end

// Combine both phases to create uniform 3.5x divided clock
assign clk_div = clk_pos | clk_neg;

endmodule