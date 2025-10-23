module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam THRESHOLD = (NUM_DIV - 1) / 2;
    reg [$clog2(NUM_DIV)-1:0] cnt_p, cnt_n;
    reg clk_p, clk_n;

    // Positive edge counter and divider
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_p <= 0;
            clk_p <= 0;
        end
        else begin
            if (cnt_p == NUM_DIV - 1)
                cnt_p <= 0;
            else
                cnt_p <= cnt_p + 1;

            if (cnt_p == THRESHOLD || cnt_p == NUM_DIV - 1)
                clk_p <= ~clk_p;
        end
    end

    // Negative edge counter and divider
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_n <= 0;
            clk_n <= 1;  // Initialize to 1 for proper phase
        end
        else begin
            if (cnt_n == NUM_DIV - 1)
                cnt_n <= 0;
            else
                cnt_n <= cnt_n + 1;

            if (cnt_n == THRESHOLD || cnt_n == NUM_DIV - 1)
                clk_n <= ~clk_n;
        end
    end

    // Combine both divided clocks
    assign clk_div = clk_p | clk_n;

endmodule