module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg clk_a, clk_b;

// Single counter (0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
    end else begin
        counter <= (counter == 3'd6) ? 3'b0 : counter + 1'b1;
    end
end

// Phase A: high for first 4 cycles
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a <= 1'b0;
    end else begin
        clk_a <= (counter < 3'd4);
    end
end

// Phase B: inverted and half-cycle delayed version
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_b <= 1'b0;
    end else begin
        clk_b <= ~(counter < 3'd4);
    end
end

// Final output combines both phases
assign clk_div = clk_a | clk_b;

endmodule