module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam HALF = (NUM_DIV - 1) / 2;  // Half point for toggling

    // Counter width
    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    reg [COUNTER_WIDTH-1:0] cnt1;  // Counts on posedge clk
    reg [COUNTER_WIDTH-1:0] cnt2;  // Counts on negedge clk

    reg clk_div1;  // Divided clock from positive edge domain
    reg clk_div2;  // Divided clock from negative edge domain

    // Counter and clk_div1 toggling on positive edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;  // Toggle clk_div1 at full count
            end else begin
                cnt1 <= cnt1 + 1;
                if (cnt1 == HALF) begin
                    clk_div1 <= ~clk_div1;  // Toggle clk_div1 at half count
                end
            end
        end
    end

    // Counter and clk_div2 toggling on negative edge of clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;  // Toggle clk_div2 at full count
            end else begin
                cnt2 <= cnt2 + 1;
                if (cnt2 == HALF) begin
                    clk_div2 <= ~clk_div2;  // Toggle clk_div2 at half count
                end
            end
        end
    end

    // Final output clock is the OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule