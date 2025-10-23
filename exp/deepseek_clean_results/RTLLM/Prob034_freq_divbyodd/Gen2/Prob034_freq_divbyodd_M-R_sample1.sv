module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    reg [$clog2(NUM_DIV):0] cnt_p, cnt_n;
    reg clk_div_p, clk_div_n;
    localparam HALF_DIV = NUM_DIV >> 1;  // Arithmetic right shift for division by 2

    // Combined counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_p <= 0;
            clk_div_p <= 0;
        end else begin
            cnt_p <= (cnt_p == NUM_DIV - 1) ? 0 : cnt_p + 1;
        end
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_n <= 0;
            clk_div_n <= 0;
        end else begin
            cnt_n <= (cnt_n == NUM_DIV - 1) ? 0 : cnt_n + 1;
        end
    end

    // Toggle logic using continuous assignments
    assign clk_div_p = (!rst_n) ? 0 : 
                      (cnt_p == HALF_DIV || cnt_p == NUM_DIV - 1) ? ~clk_div_p : clk_div_p;
    
    assign clk_div_n = (!rst_n) ? 0 : 
                      (cnt_n == HALF_DIV || cnt_n == NUM_DIV - 1) ? ~clk_div_n : clk_div_n;

    // Final output combination
    assign clk_div = clk_div_p | clk_div_n;

endmodule