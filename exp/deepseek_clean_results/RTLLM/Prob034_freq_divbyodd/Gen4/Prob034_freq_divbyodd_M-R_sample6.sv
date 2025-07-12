module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam TOGGLE_POINT = (NUM_DIV - 1) / 2;
    
    reg [CNT_WIDTH-1:0] cnt_p, cnt_n;
    wire p_toggle, n_toggle;
    reg div_p, div_n;

    // Positive edge toggle condition
    assign p_toggle = (cnt_p == TOGGLE_POINT);

    // Negative edge toggle condition
    assign n_toggle = (cnt_n == TOGGLE_POINT);

    // Positive edge counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_p <= 0;
            div_p <= 0;
        end else begin
            cnt_p <= (cnt_p == NUM_DIV-1) ? 0 : cnt_p + 1;
            if (p_toggle) div_p <= ~div_p;
        end
    end

    // Negative edge counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_n <= 0;
            div_n <= 0;
        end else begin
            cnt_n <= (cnt_n == NUM_DIV-1) ? 0 : cnt_n + 1;
            if (n_toggle) div_n <= ~div_n;
        end
    end

    // Combine with OR for proper edge alignment
    assign clk_div = div_p | div_n;

endmodule