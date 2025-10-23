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
reg [$clog2(NUM_DIV):0] cnt_half;   // Counter to track the midpoint
reg prev_clk_div;                   // Previous state of clk_div

// Sequential logic for counter update and divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= '0;
        cnt_half <= '0;
        clk_div <= 1'b0;
        prev_clk_div <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV - 1)) begin
            cnt <= '0;
            cnt_half <= '0;
            clk_div <= ~prev_clk_div;
            prev_clk_div <= ~prev_clk_div;
        end else begin
            cnt <= cnt + 1;
            if (cnt == (NUM_DIV / 2)) begin
                cnt_half <= cnt;
            end
        end
    end
end

endmodule