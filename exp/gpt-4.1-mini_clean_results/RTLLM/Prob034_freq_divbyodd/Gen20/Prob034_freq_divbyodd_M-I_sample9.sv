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

    // Counter width
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    // clk_div1 toggles on positive edge when cnt hits toggle points (0, HALF_DIV)
    reg clk_div1;

    // To generate clk_div2 toggling on negedge clk, store toggle enable on posedge clk
    reg toggle_neg_edge;

    // clk_div2 toggles on negedge clk when toggle_neg_edge is asserted
    reg clk_div2;

    // Counter increments on positive edge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div1 <= 0;
            toggle_neg_edge <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // Toggle clk_div1 at cnt == 0 or cnt == HALF_DIV
            if (cnt == 0 || cnt == HALF_DIV)
                clk_div1 <= ~clk_div1;

            // Set toggle_neg_edge high for negedge toggle when cnt is 1 or HALF_DIV+1
            // This anticipates toggle on negedge clk by flagging one count after toggle points
            toggle_neg_edge <= (cnt == 1 || cnt == (HALF_DIV + 1));
        end
    end

    // clk_div2 toggles on negedge clk if toggle_neg_edge is asserted
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 0;
        end else begin
            if (toggle_neg_edge)
                clk_div2 <= ~clk_div2;
        end
    end

    // Final divided clock is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule