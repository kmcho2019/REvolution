module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam HALF_DIV = (NUM_DIV - 1) / 2;
    reg [$clog2(NUM_DIV):0] cnt_p, cnt_n;
    reg clk_p, clk_n;

    // Positive edge counter and clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_p <= 0;
            clk_p <= 0;
        end else begin
            if (cnt_p == NUM_DIV - 1) begin
                cnt_p <= 0;
                clk_p <= ~clk_p;
            end else begin
                cnt_p <= cnt_p + 1;
            end
        end
    end

    // Negative edge counter and clock
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_n <= 0;
            clk_n <= 0;
        end else begin
            if (cnt_n == NUM_DIV - 1) begin
                cnt_n <= 0;
                clk_n <= ~clk_n;
            end else begin
                cnt_n <= cnt_n + 1;
            end
        end
    end

    // Combine both clocks
    assign clk_div = clk_p | clk_n;

endmodule