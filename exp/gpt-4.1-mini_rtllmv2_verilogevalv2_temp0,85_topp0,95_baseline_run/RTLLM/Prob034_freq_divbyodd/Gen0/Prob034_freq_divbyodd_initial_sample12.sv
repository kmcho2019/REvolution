module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be an odd number
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Half period count (integer division)
    localparam HALF_DIV = NUM_DIV >> 1; 

    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg [$clog2(NUM_DIV)-1:0] cnt2;

    reg clk_div1;
    reg clk_div2;

    // Counter and clk_div1 on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else if (cnt1 == NUM_DIV - 1) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end else if (cnt1 == HALF_DIV) begin
            clk_div1 <= ~clk_div1;
            cnt1 <= cnt1 + 1;
        end else begin
            cnt1 <= cnt1 + 1;
        end
    end

    // Counter and clk_div2 on negative edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else if (cnt2 == NUM_DIV - 1) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end else if (cnt2 == HALF_DIV) begin
            clk_div2 <= ~clk_div2;
            cnt2 <= cnt2 + 1;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end

    // Output clock is OR of both divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule