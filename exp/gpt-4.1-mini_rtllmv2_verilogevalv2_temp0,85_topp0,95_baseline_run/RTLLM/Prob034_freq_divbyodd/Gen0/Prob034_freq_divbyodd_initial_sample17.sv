module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be an odd number
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counters for posedge and negedge
    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg [$clog2(NUM_DIV)-1:0] cnt2;

    // Divided clocks for posedge and negedge
    reg clk_div1;
    reg clk_div2;

    // Half point for toggling
    localparam HALF = NUM_DIV >> 1;  // integer division by 2

    // Positive edge counter and clk_div1 toggle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else if (cnt1 == HALF) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= cnt1 + 1;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end
    end

    // Negative edge counter and clk_div2 toggle
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else if (cnt2 == HALF) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= cnt2 + 1;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end

    // Final divided clock output is the OR of both halves
    assign clk_div = clk_div1 | clk_div2;

endmodule