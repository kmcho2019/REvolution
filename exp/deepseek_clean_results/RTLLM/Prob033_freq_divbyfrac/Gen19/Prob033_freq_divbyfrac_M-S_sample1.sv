module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_pos;
reg clk_neg;

// Counter logic (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Rising edge clock (toggles every 3.5 cycles)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_pos <= 1'b0;
    end else if (counter == 3'd3 || counter == 3'd6) begin
        clk_pos <= ~clk_pos;
    end
end

// Falling edge clock (toggles every 3.5 cycles with phase shift)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_neg <= 1'b0;
    end else if (counter == 3'd3 || counter == 3'd6) begin
        clk_neg <= ~clk_neg;
    end
end

// Combine both clocks for final output
assign clk_div = clk_pos | clk_neg;

endmodule