module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Assert NUM_DIV is odd and >= 3 for proper operation
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    localparam HALF_DIV = NUM_DIV >> 1; // integer division by 2

    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg [$clog2(NUM_DIV)-1:0] cnt2;
    reg clk_div1;
    reg clk_div2;

    // Counter cnt1 and clk_div1 toggled on posedge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1    <= 0;
            clk_div1 <= 0;
        end else if (cnt1 == NUM_DIV - 1) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end else if (cnt1 == HALF_DIV) begin
            cnt1 <= cnt1 + 1;
            clk_div1 <= ~clk_div1;
        end else begin
            cnt1 <= cnt1 + 1;
        end
    end

    // Counter cnt2 and clk_div2 toggled on negedge of clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2    <= 0;
            clk_div2 <= 0;
        end else if (cnt2 == NUM_DIV - 1) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end else if (cnt2 == HALF_DIV) begin
            cnt2 <= cnt2 + 1;
            clk_div2 <= ~clk_div2;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end

    // Output clock is logical OR of two divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule