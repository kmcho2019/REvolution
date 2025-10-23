module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg rising_toggle;
reg falling_toggle;

// Main counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Rising edge toggle (count 0 and 3)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rising_toggle <= 1'b0;
    end else if (counter == 3'd0 || counter == 3'd3) begin
        rising_toggle <= ~rising_toggle;
    end
end

// Falling edge toggle (count 1)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        falling_toggle <= 1'b0;
    end else if (counter == 3'd1) begin
        falling_toggle <= ~falling_toggle;
    end
end

// Combine both edge-triggered signals
assign clk_div = rising_toggle ^ falling_toggle;

endmodule