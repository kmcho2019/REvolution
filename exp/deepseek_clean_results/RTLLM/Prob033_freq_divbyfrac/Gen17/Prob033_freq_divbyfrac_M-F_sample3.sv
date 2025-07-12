module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

reg [2:0] counter_a;
reg [2:0] counter_b;
reg clk_a, clk_b;

// Phase A counter (posedge, 0-6)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter_a <= 3'b0;
        clk_a <= 1'b0;
    end else begin
        counter_a <= (counter_a == 3'd6) ? 3'b0 : counter_a + 1'b1;
        clk_a <= (counter_a < 3'd4);
    end
end

// Phase B counter (negedge, 0-6 with 3.5 cycle shift)
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter_b <= 3'd4;  // Initial shift of 3.5 cycles (4 counts)
        clk_b <= 1'b0;
    end else begin
        counter_b <= (counter_b == 3'd6) ? 3'b0 : counter_b + 1'b1;
        clk_b <= (counter_b < 3'd4);
    end
end

// Registered output combination
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_a | clk_b;
    end
end

endmodule