module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be an odd number >= 3
)(
    input  wire clk,
    input  wire rst_n,    // Active low synchronous reset
    output wire clk_div
);

    // Compile-time parameter check
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV parameter must be an odd number and >= 3.");
        end
    end

    localparam integer MAX_COUNT = NUM_DIV - 1;
    localparam integer HALF_COUNT = (NUM_DIV - 1) >> 1;  // (NUM_DIV -1)/2

    // Calculate required width for counters
    localparam integer CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt1;
    reg [CNT_WIDTH-1:0] cnt2;
    reg clk_div1;
    reg clk_div2;

    // Counter and clk_div1 toggling on posedge clk with synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt1 == MAX_COUNT) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else if (cnt1 == HALF_COUNT) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= cnt1 + 1;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end
    end

    // Counter and clk_div2 toggling on negedge clk with synchronous reset
    always @(negedge clk) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 1'b0;
        end else begin
            if (cnt2 == MAX_COUNT) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else if (cnt2 == HALF_COUNT) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= cnt2 + 1;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end

    // Combine the two divided clocks with OR to get final output
    assign clk_div = clk_div1 | clk_div2;

endmodule