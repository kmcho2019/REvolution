module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be an odd number
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

    // Calculate half point (integer division)
    localparam HALF_DIV = NUM_DIV >> 1;

    // Counter width to hold values up to NUM_DIV-1
    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    // Positive edge counter and clk_div1
    reg [COUNTER_WIDTH-1:0] cnt1;
    reg                     clk_div1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1     <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1     <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                cnt1 <= cnt1 + 1;
                // Toggle clk_div1 when reaching HALF_DIV (only once per cycle)
                if (cnt1 == HALF_DIV - 1)
                    clk_div1 <= ~clk_div1;
            end
        end
    end

    // Negative edge counter and clk_div2
    reg [COUNTER_WIDTH-1:0] cnt2;
    reg                     clk_div2;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2     <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2     <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt2 <= cnt2 + 1;
                // Toggle clk_div2 when reaching HALF_DIV (only once per cycle)
                if (cnt2 == HALF_DIV - 1)
                    clk_div2 <= ~clk_div2;
            end
        end
    end

    // Combined output clock by OR-ing clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule