module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam HALF_DIV = (NUM_DIV - 1) / 2;
    
    reg [CNT_WIDTH-1:0] cnt_p, cnt_n;
    reg div_p, div_n;

    // Positive edge counter and divider
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_p <= 0;
            div_p <= 0;
        end else begin
            if (cnt_p == NUM_DIV - 1) begin
                cnt_p <= 0;
                div_p <= ~div_p;
            end else begin
                cnt_p <= cnt_p + 1;
            end
        end
    end

    // Negative edge counter and divider
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_n <= 0;
            div_n <= 0;
        end else begin
            if (cnt_n == NUM_DIV - 1) begin
                cnt_n <= 0;
                div_n <= ~div_n;
            end else begin
                cnt_n <= cnt_n + 1;
            end
        end
    end

    // Combine with XOR for clean transitions
    assign clk_div = div_p ^ div_n;

endmodule