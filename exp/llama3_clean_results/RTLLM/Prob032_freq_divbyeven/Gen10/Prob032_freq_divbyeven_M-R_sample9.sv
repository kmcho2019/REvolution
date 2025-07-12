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

reg [3:0] cnt;        // 4-bit counter to track clock cycles
reg prev_clk_div;     // Previous state of divided clock signal
wire cnt_reached;     // Signal indicating counter has reached threshold

// Combinational logic to check if counter has reached threshold
assign cnt_reached = (cnt == (NUM_DIV/2 - 1));

// Sequential logic for counter update and divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= '0;
        prev_clk_div <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt_reached) begin
            cnt <= '0;
            prev_clk_div <= ~prev_clk_div;
            clk_div <= prev_clk_div;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule