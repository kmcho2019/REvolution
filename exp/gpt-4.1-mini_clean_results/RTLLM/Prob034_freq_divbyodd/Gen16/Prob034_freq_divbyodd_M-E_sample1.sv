module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // active low synchronous reset
    output wire clk_div
);

    // Compile-time check: NUM_DIV must be odd and >=3
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV parameter must be an odd number >= 3.");
        end
    end

    // Width for counters
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt_pos;
    reg [CNT_WIDTH-1:0] cnt_neg;

    reg clk_div_pos;
    reg clk_div_neg;

    // Positive edge counter and toggling clk_div_pos
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 0;
            clk_div_pos <= 1'b0;
        end else begin
            if (cnt_pos == NUM_DIV - 1) begin
                cnt_pos <= 0;
                clk_div_pos <= ~clk_div_pos;
            end else begin
                cnt_pos <= cnt_pos + 1;
            end
        end
    end

    // Negative edge counter and toggling clk_div_neg
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 0;
            clk_div_neg <= 1'b0;
        end else begin
            if (cnt_neg == NUM_DIV - 1) begin
                cnt_neg <= 0;
                clk_div_neg <= ~clk_div_neg;
            end else begin
                cnt_neg <= cnt_neg + 1;
            end
        end
    end

    // Final output clock is OR of both divided clocks
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule