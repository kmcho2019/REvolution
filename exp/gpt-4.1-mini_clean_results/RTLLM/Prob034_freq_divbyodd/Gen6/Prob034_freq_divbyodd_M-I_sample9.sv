module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd and >=1
)(
    input  wire clk,
    input  wire rst_n,    // Active low synchronous reset
    output wire clk_div
);

    // Assert NUM_DIV is odd and >=1 at elaboration time
    initial begin
        if (NUM_DIV < 1) begin
            $error("NUM_DIV parameter must be >= 1");
        end
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be odd");
        end
    end

    // Special case: if NUM_DIV == 1, output clk_div = clk (no division)
    generate
    if (NUM_DIV == 1) begin
        assign clk_div = clk;
    end else begin : gen_divider

        localparam integer HALF_DIV = (NUM_DIV - 1) / 2; // half count for toggling

        // Width of counters
        localparam integer CNT_WIDTH = $clog2(NUM_DIV);

        reg [CNT_WIDTH-1:0] cnt1 = 0;
        reg [CNT_WIDTH-1:0] cnt2 = 0;

        reg clk_div1 = 0;
        reg clk_div2 = 0;

        // Synchronous reset: counters and clk_div1 toggle on rising edge
        always @(posedge clk) begin
            if (!rst_n) begin
                cnt1 <= 0;
                clk_div1 <= 0;
            end else begin
                if (cnt1 == HALF_DIV) begin
                    cnt1 <= 0;
                    clk_div1 <= ~clk_div1;
                end else begin
                    cnt1 <= cnt1 + 1'b1;
                end
            end
        end

        // Synchronous reset: counters and clk_div2 toggle on falling edge
        always @(negedge clk) begin
            if (!rst_n) begin
                cnt2 <= 0;
                clk_div2 <= 0;
            end else begin
                if (cnt2 == HALF_DIV) begin
                    cnt2 <= 0;
                    clk_div2 <= ~clk_div2;
                end else begin
                    cnt2 <= cnt2 + 1'b1;
                end
            end
        end

        // OR the two divided clocks to produce the final output
        assign clk_div = clk_div1 | clk_div2;

    end
    endgenerate

endmodule