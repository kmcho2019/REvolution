module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd and >= 3
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output wire clk_div
);

    // Sanity check: NUM_DIV must be odd and >=3
    initial begin
        if ((NUM_DIV < 3) || (NUM_DIV % 2 == 0)) begin
            $error("NUM_DIV parameter must be an odd number >= 3.");
        end
    end

    localparam integer HALF_DIV = (NUM_DIV - 1) >> 1; // (NUM_DIV-1)/2
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counters for posedge and negedge counting
    reg [CNT_WIDTH-1:0] cnt1;
    reg [CNT_WIDTH-1:0] cnt2;

    // Clock divider outputs toggled on respective edges
    reg clk_div1;
    reg clk_div2;

    // Counter and clk_div1 on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;

            // Toggle clk_div1 when cnt1 reaches HALF_DIV
            if (cnt1 == HALF_DIV)
                clk_div1 <= ~clk_div1;
        end
    end

    // Counter and clk_div2 on negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 1'b0;
        end else begin
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;

            // Toggle clk_div2 when cnt2 reaches HALF_DIV
            if (cnt2 == HALF_DIV)
                clk_div2 <= ~clk_div2;
        end
    end

    // Output clock is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule