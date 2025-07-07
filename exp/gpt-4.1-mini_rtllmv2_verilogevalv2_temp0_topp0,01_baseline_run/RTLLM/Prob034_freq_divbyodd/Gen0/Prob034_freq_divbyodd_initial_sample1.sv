module freq_divbyodd #(
    parameter NUM_DIV = 5
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counters for rising and falling edges
    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg [$clog2(NUM_DIV)-1:0] cnt2;

    // Divided clocks for rising and falling edges
    reg clk_div1;
    reg clk_div2;

    // Half point for toggling
    localparam HALF_DIV = NUM_DIV >> 1; // integer division by 2

    // Rising edge counter and clk_div1 toggle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                cnt1 <= cnt1 + 1;
                if (cnt1 == HALF_DIV - 1) begin
                    clk_div1 <= ~clk_div1;
                end
            end
        end
    end

    // Falling edge counter and clk_div2 toggle
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt2 <= cnt2 + 1;
                if (cnt2 == HALF_DIV - 1) begin
                    clk_div2 <= ~clk_div2;
                end
            end
        end
    end

    // Final divided clock output is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule