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

    localparam integer HALF_DIV = (NUM_DIV - 1) / 2;  // midpoint count
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt1;  // counts posedge clk
    reg [CNT_WIDTH-1:0] cnt2;  // counts negedge clk

    reg clk_div1;
    reg clk_div2;

    wire toggle1_enable;
    wire toggle2_enable;

    // Counter 1 (posedge clk)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1     <= 0;
            clk_div1 <= 0;
        end else begin
            // Increment or wrap counter
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;

            // Toggle clk_div1 at the midpoint count
            if (cnt1 == HALF_DIV)
                clk_div1 <= ~clk_div1;
        end
    end

    // Counter 2 (negedge clk)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2     <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;

            if (cnt2 == HALF_DIV)
                clk_div2 <= ~clk_div2;
        end
    end

    assign clk_div = clk_div1 | clk_div2;

endmodule