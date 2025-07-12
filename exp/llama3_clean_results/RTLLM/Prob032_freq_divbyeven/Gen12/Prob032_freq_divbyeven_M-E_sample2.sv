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

reg [$clog2(NUM_DIV):0] cnt;        // Dynamic counter size based on NUM_DIV
reg prev_clk_div;                   // Previous state of clk_div
reg enable_cnt;                     // Enable signal for counter

// Sequential logic for counter update and divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= '0;
        clk_div <= 1'b0;
        prev_clk_div <= 1'b0;
        enable_cnt <= 1'b1;
    end else begin
        if (enable_cnt) begin
            if (cnt == (NUM_DIV / 2 - 1)) begin
                cnt <= '0;
                clk_div <= ~prev_clk_div;
                prev_clk_div <= ~prev_clk_div;
            end else begin
                cnt <= cnt + 1;
            end
        end
        // Power-saving feature: disable counter when clk_div is stabilized
        if (cnt == 0 && prev_clk_div == clk_div) begin
            enable_cnt <= 1'b0;
        end else if (prev_clk_div != clk_div) begin
            enable_cnt <= 1'b1;
        end
    end
end

endmodule