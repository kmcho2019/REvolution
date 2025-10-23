module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2; // floor division

    // Width for counter (minimum bits to count up to NUM_DIV-1)
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    reg clk_div1, clk_div2;

    // A delayed version of the toggling condition for clk_div2
    reg toggle_clk_div2_d;

    // Counter and clk_div1 toggle logic on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // Toggle clk_div1 at counts 0 and HALF_DIV
            if (cnt == 0 || cnt == HALF_DIV)
                clk_div1 <= ~clk_div1;
        end
    end

    // Generate toggle condition for clk_div2 combinationally
    wire toggle_clk_div2 = (cnt == 0 || cnt == HALF_DIV);

    // Delay toggle condition by one clock to emulate negedge effect
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            toggle_clk_div2_d <= 1'b0;
            clk_div2          <= 1'b0;
        end else begin
            toggle_clk_div2_d <= toggle_clk_div2;
            if (toggle_clk_div2_d)
                clk_div2 <= ~clk_div2;
        end
    end

    assign clk_div = clk_div1 | clk_div2;

endmodule