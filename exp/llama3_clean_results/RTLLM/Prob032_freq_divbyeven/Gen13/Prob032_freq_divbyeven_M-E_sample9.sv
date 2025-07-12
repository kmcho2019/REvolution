module freq_diveven #(
    parameter NUM_DIV = 4  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Validate NUM_DIV as an even number and greater than 1 at compile-time
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be an even number.");
        $finish;
    end
    if (NUM_DIV < 2) begin
        $error("NUM_DIV must be greater than 1.");
        $finish;
    end
end

reg [NUM_DIV-1:0] slow_cnt;  // Slow counter
reg [$clog2(NUM_DIV):0] fast_cnt;  // Fast counter
reg prev_clk_div;  // Previous state of clk_div

// Sequential logic for counter update and divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        slow_cnt <= '0;
        fast_cnt <= '0;
        clk_div <= 1'b0;
        prev_clk_div <= 1'b0;
    end else begin
        if (slow_cnt == NUM_DIV - 1) begin
            slow_cnt <= '0;
            if (fast_cnt == NUM_DIV / 2 - 1) begin
                fast_cnt <= '0;
                clk_div <= ~prev_clk_div;
                prev_clk_div <= ~prev_clk_div;
            end else begin
                fast_cnt <= fast_cnt + 1;
            end
        end else begin
            slow_cnt <= slow_cnt + 1;
            if (fast_cnt == NUM_DIV / 2 - 1) begin
                fast_cnt <= '0;
                clk_div <= ~prev_clk_div;
                prev_clk_div <= ~prev_clk_div;
            end else begin
                fast_cnt <= fast_cnt + 1;
            end
        end
    end
end

endmodule