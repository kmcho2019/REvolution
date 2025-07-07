module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be an odd number
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Check that NUM_DIV is odd at compile time
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
            $finish;
        end
    end

    localparam HALF_DIV = NUM_DIV >> 1; // integer division by 2

    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg [$clog2(NUM_DIV)-1:0] cnt2;
    reg clk_div1;
    reg clk_div2;

    // Counter and clk_div1 toggling on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end

            if (cnt1 == HALF_DIV - 1) begin
                clk_div1 <= ~clk_div1;
            end
        end
    end

    // Counter and clk_div2 toggling on negative edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end

            if (cnt2 == HALF_DIV - 1) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end

    // Final divided clock output is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule