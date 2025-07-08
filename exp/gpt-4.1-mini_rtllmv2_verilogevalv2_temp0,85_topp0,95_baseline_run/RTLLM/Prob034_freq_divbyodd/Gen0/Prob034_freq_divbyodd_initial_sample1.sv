module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be an odd number
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Half period count: integer division
    localparam HALF_DIV = NUM_DIV >> 1;  // NUM_DIV / 2 for odd NUM_DIV

    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg [$clog2(NUM_DIV)-1:0] cnt2;
    reg clk_div1;
    reg clk_div2;

    // Counter and clk_div1 logic - rising edge domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1     <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end

            if (cnt1 == HALF_DIV) begin
                clk_div1 <= ~clk_div1;
            end
        end
    end

    // Counter and clk_div2 logic - falling edge domain
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2     <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end

            if (cnt2 == HALF_DIV) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end

    // Output clock is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule