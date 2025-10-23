module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2;  // floor division

    // Minimum width needed for counters
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt_pos;
    reg [CNT_WIDTH-1:0] cnt_neg;

    reg clk_div_pos;
    reg clk_div_neg;

    // Positive edge counter and clk_div_pos generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos     <= 0;
            clk_div_pos <= 0;
        end else begin
            if (cnt_pos == NUM_DIV - 1)
                cnt_pos <= 0;
            else
                cnt_pos <= cnt_pos + 1;

            // Generate pulse for clk_div_pos:
            // Set high at count 0, clear at HALF_DIV
            if (cnt_pos == 0)
                clk_div_pos <= 1'b1;
            else if (cnt_pos == HALF_DIV)
                clk_div_pos <= 1'b0;
            // else maintain current state
        end
    end

    // Negative edge counter and clk_div_neg generation
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg     <= 0;
            clk_div_neg <= 0;
        end else begin
            if (cnt_neg == NUM_DIV - 1)
                cnt_neg <= 0;
            else
                cnt_neg <= cnt_neg + 1;

            // Generate pulse for clk_div_neg:
            // Set high at count 0, clear at HALF_DIV
            if (cnt_neg == 0)
                clk_div_neg <= 1'b1;
            else if (cnt_neg == HALF_DIV)
                clk_div_neg <= 1'b0;
            // else maintain current state
        end
    end

    // Final divided clock output combines both edges
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule