module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    // Parameter check
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    localparam HALF_COUNT = (NUM_DIV - 1) >> 1;
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counters on posedge and negedge clk
    reg [CNT_WIDTH-1:0] cnt_pos, cnt_neg;

    // Generate pulse at HALF_COUNT on posedge
    wire pulse_pos = (cnt_pos == HALF_COUNT);
    // Generate pulse at HALF_COUNT on negedge
    wire pulse_neg = (cnt_neg == HALF_COUNT);

    // clk_div1 and clk_div2 toggles on pulses
    reg clk_div1, clk_div2;

    // Synchronize clk_div2 to posedge clk domain to reduce glitches
    reg sync_clk_div2_0, sync_clk_div2_1;

    // Positive edge domain counter and toggle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 0;
            clk_div1 <= 0;
            sync_clk_div2_0 <= 0;
            sync_clk_div2_1 <= 0;
        end else begin
            if (cnt_pos == NUM_DIV - 1) 
                cnt_pos <= 0;
            else
                cnt_pos <= cnt_pos + 1;

            // Toggle clk_div1 once per full cycle, at pulse_pos
            if (pulse_pos)
                clk_div1 <= ~clk_div1;

            // Synchronize clk_div2 to posedge domain
            sync_clk_div2_0 <= clk_div2;
            sync_clk_div2_1 <= sync_clk_div2_0;
        end
    end

    // Negative edge domain counter and toggle
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt_neg == NUM_DIV - 1) 
                cnt_neg <= 0;
            else
                cnt_neg <= cnt_neg + 1;

            // Toggle clk_div2 once per full cycle, at pulse_neg
            if (pulse_neg)
                clk_div2 <= ~clk_div2;
        end
    end

    // Combine divided clocks: clk_div1 (posedge domain) and synchronized clk_div2
    assign clk_div = clk_div1 | sync_clk_div2_1;

endmodule