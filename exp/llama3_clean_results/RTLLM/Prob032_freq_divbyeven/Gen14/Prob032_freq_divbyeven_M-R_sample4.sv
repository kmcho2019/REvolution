// Frequency divider module by even numbers
module freq_div_even #(
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

reg [$clog2(NUM_DIV):0] cnt;        // Counter to track clock cycles
reg prev_clk_div;                    // Previous divided clock output

// Sequential logic for counter update
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= '0;
        prev_clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV/2 - 1)) begin
            cnt <= cnt + 1;
        end else begin
            cnt <= '0;
            prev_clk_div <= ~prev_clk_div;
        end
    end
end

// Combinational logic for divided clock output
assign clk_div = prev_clk_div;

endmodule