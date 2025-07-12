module freq_divbyfrac (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

reg [2:0] counter;
reg phase;

// Counter with explicit rollover
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b0;
        phase <= 1'b0;
    end else begin
        if (counter == 3'd6) begin
            counter <= 3'b0;
            phase <= ~phase;  // Toggle phase every full cycle
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

// Clock generation using continuous assignments
wire clk_a = (counter < 3'd4) & phase;
wire clk_b = (counter < 3'd3) & ~phase;

// Phase-shifted versions using both edges
reg clk_a_shift, clk_b_shift;
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_a_shift <= 1'b0;
        clk_b_shift <= 1'b0;
    end else begin
        clk_a_shift <= clk_a;
        clk_b_shift <= clk_b;
    end
end

// Final output combines all phases
assign clk_div = (clk_a | clk_a_shift) | (clk_b | clk_b_shift);

endmodule