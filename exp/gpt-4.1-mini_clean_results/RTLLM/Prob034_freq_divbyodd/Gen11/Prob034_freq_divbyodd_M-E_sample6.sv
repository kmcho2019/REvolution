module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Compile-time check: NUM_DIV must be odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam HALF = (NUM_DIV - 1) >> 1;  // (NUM_DIV-1)/2

    // Width of counters to count up to NUM_DIV-1
    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    // Counters for posedge and negedge
    reg [COUNTER_WIDTH-1:0] cnt_pos;
    reg [COUNTER_WIDTH-1:0] cnt_neg;

    // Clock dividers toggled on posedge and negedge counters
    reg clk_div1;
    reg clk_div2;

    // Counter and clk_div1 on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt_pos == NUM_DIV - 1)
                cnt_pos <= 0;
            else
                cnt_pos <= cnt_pos + 1;

            if (cnt_pos == HALF)
                clk_div1 <= ~clk_div1;
        end
    end

    // Counter and clk_div2 on negative edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt_neg == NUM_DIV - 1)
                cnt_neg <= 0;
            else
                cnt_neg <= cnt_neg + 1;

            if (cnt_neg == HALF)
                clk_div2 <= ~clk_div2;
        end
    end

    // Output clock is OR of both dividers
    assign clk_div = clk_div1 | clk_div2;

endmodule