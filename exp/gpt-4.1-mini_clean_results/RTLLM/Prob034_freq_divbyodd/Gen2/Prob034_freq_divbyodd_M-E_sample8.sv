module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be odd, but is %0d", NUM_DIV);
        end
    end

    localparam HALF_COUNT = (NUM_DIV - 1) / 2;
    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    // Counters for posedge and negedge counting
    reg [COUNTER_WIDTH-1:0] cnt1;
    reg [COUNTER_WIDTH-1:0] cnt2;

    // Divided clocks toggled on posedge and negedge respectively
    reg clk_div1;
    reg clk_div2;

    // Counter and toggle logic on positive edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                // Toggle clk_div1 at end of count cycle
                clk_div1 <= ~clk_div1;
            end else begin
                cnt1 <= cnt1 + 1;
                // Toggle clk_div1 at half_count
                if (cnt1 == HALF_COUNT) begin
                    clk_div1 <= ~clk_div1;
                end
            end
        end
    end

    // Counter and toggle logic on negative edge of clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                // Toggle clk_div2 at end of count cycle
                clk_div2 <= ~clk_div2;
            end else begin
                cnt2 <= cnt2 + 1;
                // Toggle clk_div2 at half_count
                if (cnt2 == HALF_COUNT) begin
                    clk_div2 <= ~clk_div2;
                end
            end
        end
    end

    // Combine clk_div1 and clk_div2 to generate output clock
    assign clk_div = clk_div1 | clk_div2;

endmodule