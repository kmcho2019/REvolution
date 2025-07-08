module freq_divbyodd #(
    parameter NUM_DIV = 5
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Validate that NUM_DIV is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be odd. Current value: %0d", NUM_DIV);
            $finish;
        end
    end

    localparam HALF_DIV = (NUM_DIV - 1) >> 1;  // Half divisor count

    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg [$clog2(NUM_DIV)-1:0] cnt2;
    reg clk_div1;
    reg clk_div2;

    // Counter and clk_div1 toggling on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1    <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else if (cnt1 == HALF_DIV) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= cnt1 + 1;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end
    end

    // Counter and clk_div2 toggling on falling edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2    <= 0;
            clk_div2 <= 1'b0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else if (cnt2 == HALF_DIV) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= cnt2 + 1;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end

    // Final divided clock output as OR of both divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule