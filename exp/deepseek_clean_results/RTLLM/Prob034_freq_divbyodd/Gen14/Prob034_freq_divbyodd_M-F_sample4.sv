module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    // Validate parameter is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be an odd number");
            $finish;
        end
    end

    localparam CNT_MAX = NUM_DIV - 1;
    localparam TOGGLE_POINT = (NUM_DIV - 1) / 2;
    localparam CNT_WIDTH = $clog2(CNT_MAX + 1);

    reg [CNT_WIDTH-1:0] cnt1, cnt2;
    reg clk_div1, clk_div2;

    // Positive edge counter and divider
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == CNT_MAX) begin
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end

            if (cnt1 == TOGGLE_POINT || cnt1 == CNT_MAX) begin
                clk_div1 <= ~clk_div1;
            end
        end
    end

    // Negative edge counter and divider
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == CNT_MAX) begin
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end

            if (cnt2 == TOGGLE_POINT || cnt2 == CNT_MAX) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end

    // Combine both divider signals
    assign clk_div = clk_div1 | clk_div2;

endmodule