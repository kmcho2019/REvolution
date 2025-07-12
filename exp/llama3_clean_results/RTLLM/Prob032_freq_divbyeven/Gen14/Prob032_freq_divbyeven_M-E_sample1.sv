// Frequency divider module by even numbers
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

reg [3:0] cnt_lo;    // Lower counter for clock cycle counting
reg [3:0] cnt_hi;    // Higher counter for clock cycle counting

// Sequential logic for counter update
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_lo <= '0;
        cnt_hi <= '0;
        clk_div <= 1'b0;
    end else begin
        if (cnt_lo < (NUM_DIV / 2 - 1)) begin
            cnt_lo <= cnt_lo + 1;
        end else if (cnt_lo == (NUM_DIV / 2 - 1)) begin
            cnt_lo <= '0;
            cnt_hi <= cnt_hi + 1;
        end

        if (cnt_hi == (NUM_DIV / 2 - 1)) begin
            cnt_hi <= '0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule