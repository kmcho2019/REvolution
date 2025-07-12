module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Check that NUM_DIV is odd and >= 3
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    localparam HALF_COUNT = (NUM_DIV - 1) >> 1; // (NUM_DIV-1)/2

    // Calculate required width for counters
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt_pos;  // Counter for posedge clk
    reg [CNT_WIDTH-1:0] cnt_neg;  // Counter for negedge clk

    reg clk_div1;  // Toggles at posedge half count
    reg clk_div2;  // Toggles at negedge half count

    // Counter and clk_div1 toggling on positive edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt_pos == NUM_DIV - 1) begin
                cnt_pos <= 0;
            end else begin
                cnt_pos <= cnt_pos + 1;
            end

            if (cnt_pos == HALF_COUNT) begin
                clk_div1 <= ~clk_div1;
            end
        end
    end

    // Counter and clk_div2 toggling on negative edge of clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt_neg == NUM_DIV - 1) begin
                cnt_neg <= 0;
            end else begin
                cnt_neg <= cnt_neg + 1;
            end

            if (cnt_neg == HALF_COUNT) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end

    // Final divided clock is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule