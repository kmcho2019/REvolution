module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    // Validate parameter (must be odd and >=3)
    initial begin
        if (NUM_DIV < 3 || NUM_DIV[0] == 0) begin
            $error("NUM_DIV must be odd and >=3");
            $finish;
        end
    end

    // Calculate required counter width and toggle points
    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam HALF_POINT = (NUM_DIV-1)/2;

    reg [CNT_WIDTH-1:0] cnt1, cnt2;  // Separate counters for pos/neg edges
    reg clk_div1, clk_div2;          // Separate divided clocks

    // Positive edge counter and clock divider
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt1 == NUM_DIV-1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                cnt1 <= cnt1 + 1;
                if (cnt1 == HALF_POINT) begin
                    clk_div1 <= ~clk_div1;
                end
            end
        end
    end

    // Negative edge counter and clock divider
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 1'b0;
        end else begin
            if (cnt2 == NUM_DIV-1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt2 <= cnt2 + 1;
                if (cnt2 == HALF_POINT) begin
                    clk_div2 <= ~clk_div2;
                end
            end
        end
    end

    // Combine both divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule