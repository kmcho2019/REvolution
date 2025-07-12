module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Compile-time check: NUM_DIV must be odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be odd");
        end
    end

    localparam HALF_DIV = NUM_DIV / 2;  // integer division (floor)

    // Counter width
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    reg clk_div1;
    reg clk_div2;

    // Counter increment on rising edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // Toggle clk_div1 at half division count on posedge
            if (cnt == HALF_DIV)
                clk_div1 <= ~clk_div1;
        end
    end

    // Toggle clk_div2 at full division count (just before counter resets) on negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 0;
        end else begin
            // Because cnt increments on posedge clk, at negedge clk cnt holds stable value
            // Toggle clk_div2 when cnt == NUM_DIV - 1 (end of full cycle)
            if (cnt == NUM_DIV - 1)
                clk_div2 <= ~clk_div2;
        end
    end

    assign clk_div = clk_div1 | clk_div2;

endmodule