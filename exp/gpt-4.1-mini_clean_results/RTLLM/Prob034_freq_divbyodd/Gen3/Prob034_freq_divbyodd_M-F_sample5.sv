module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Odd divisor, default 5
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Compile-time check: NUM_DIV must be odd and >= 3
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd integer >= 3");
        end
    end

    localparam integer HALF = NUM_DIV >> 1;  // floor(NUM_DIV / 2)
    localparam integer CNT_WIDTH = $clog2(NUM_DIV);

    // Counters for posedge and negedge counting
    reg [CNT_WIDTH-1:0] cnt1;
    reg [CNT_WIDTH-1:0] cnt2;

    // Divided clocks toggled on posedge and negedge events
    reg clk_div1;
    reg clk_div2;

    // Counter and toggle logic on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= clk_div1;  // No toggle at end of count
            end else if (cnt1 == HALF - 1) begin
                cnt1 <= cnt1 + 1;
                clk_div1 <= ~clk_div1; // Toggle at half count
            end else begin
                cnt1 <= cnt1 + 1;
                clk_div1 <= clk_div1;
            end
        end
    end

    // Counter and toggle logic on negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 1'b0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= clk_div2;  // No toggle at end of count
            end else if (cnt2 == HALF - 1) begin
                cnt2 <= cnt2 + 1;
                clk_div2 <= ~clk_div2; // Toggle at half count
            end else begin
                cnt2 <= cnt2 + 1;
                clk_div2 <= clk_div2;
            end
        end
    end

    // Final output clock is OR of divided clocks from pos and neg edges
    assign clk_div = clk_div1 | clk_div2;

endmodule