module freq_divbyodd #(
    parameter NUM_DIV = 5
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counters for positive and negative edge clocks
    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg [$clog2(NUM_DIV)-1:0] cnt2;

    // Divided clock outputs for posedge and negedge
    reg clk_div1;
    reg clk_div2;

    localparam HALF = NUM_DIV >> 1; // integer division by 2

    // Positive edge process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;

            if (cnt1 == HALF)
                clk_div1 <= ~clk_div1;
        end
    end

    // Negative edge process
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;

            if (cnt2 == HALF)
                clk_div2 <= ~clk_div2;
        end
    end

    // OR of both divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule