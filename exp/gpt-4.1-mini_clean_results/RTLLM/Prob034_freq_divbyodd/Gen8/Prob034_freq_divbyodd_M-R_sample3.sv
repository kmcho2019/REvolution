module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    // Parameter validation at elaboration time
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    localparam HALF_COUNT = (NUM_DIV - 1) / 2;
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counters for positive and negative edges
    reg [CNT_WIDTH-1:0] cnt1;
    reg [CNT_WIDTH-1:0] cnt2;

    // Clock divider outputs for posedge and negedge domains
    reg clk_div1;
    reg clk_div2;

    // Counter and clk_div1 toggling on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end

            // Toggle clk_div1 at half count
            if (cnt1 == HALF_COUNT) begin
                clk_div1 <= ~clk_div1;
            end
        end
    end

    // Counter and clk_div2 toggling on negative edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end

            // Toggle clk_div2 at half count
            if (cnt2 == HALF_COUNT) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end

    // Combine outputs by OR to include toggles from both edges
    assign clk_div = clk_div1 | clk_div2;

endmodule