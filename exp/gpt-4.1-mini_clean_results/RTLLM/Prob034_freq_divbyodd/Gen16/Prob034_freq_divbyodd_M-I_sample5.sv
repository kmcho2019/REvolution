module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Check at elaboration that NUM_DIV is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
            $finish;
        end
    end

    localparam MID_VAL = (NUM_DIV - 1) / 2;
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counters for posedge and negedge domains
    reg [CNT_WIDTH-1:0] cnt1;
    reg [CNT_WIDTH-1:0] cnt2;

    // Divided clocks toggled on posedge and negedge
    reg clk_div1;
    reg clk_div2;

    // posedge clk domain: count and toggle clk_div1 at MID_VAL
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1     <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                cnt1 <= cnt1 + 1;
                if (cnt1 == MID_VAL) begin
                    clk_div1 <= ~clk_div1;
                end
            end
        end
    end

    // negedge clk domain: count and toggle clk_div2 at MID_VAL
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2     <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt2 <= cnt2 + 1;
                if (cnt2 == MID_VAL) begin
                    clk_div2 <= ~clk_div2;
                end
            end
        end
    end

    // Generate output clk_div by combining clk_div1 and clk_div2:
    // Use a simple synchronizer: sample clk_div1 at posedge clk and clk_div2 at negedge clk,
    // and output clk_div = clk_div1 for posedge half cycle, clk_div2 for negedge half cycle.
    // This can be done by an MUX controlled by clk.
    // clk_div is effectively clk_div1 when clk=1, clk_div2 when clk=0, producing a stable divided clock.

    reg clk_div_r;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_r <= 0;
        else
            clk_div_r <= clk_div1;
    end

    reg clk_div_f;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_f <= 0;
        else
            clk_div_f <= clk_div2;
    end

    // Output muxed clock
    assign clk_div = clk ? clk_div_r : clk_div_f;

endmodule