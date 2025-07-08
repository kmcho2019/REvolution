module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Check NUM_DIV is odd at compile time (synthesis directive)
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be an odd number.");
            $finish;
        end
    end

    localparam HALF_DIV = (NUM_DIV - 1) >> 1;

    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg [$clog2(NUM_DIV)-1:0] cnt2;
    reg clk_div1;
    reg clk_div2;

    // Counter and clk_div1 toggling on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 1'b0;
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

    // Counter and clk_div2 toggling on negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 1'b0;
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