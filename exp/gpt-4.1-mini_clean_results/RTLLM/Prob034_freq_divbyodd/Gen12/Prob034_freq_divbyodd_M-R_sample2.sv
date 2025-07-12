module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output reg  clk_div
);

    // Compile-time check: NUM_DIV must be odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    reg [COUNTER_WIDTH-1:0] cnt;

    // Number of high clock cycles in one period: (NUM_DIV + 1) / 2
    localparam HIGH_CYCLES = (NUM_DIV + 1) >> 1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // Output clock high for first HIGH_CYCLES counts, then low
            clk_div <= (cnt < HIGH_CYCLES) ? 1'b1 : 1'b0;
        end
    end

endmodule