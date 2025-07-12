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

    // Counter on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // Toggle clk_div1 at count zero and halfway point
            if (cnt == 0 || cnt == HALF_DIV)
                clk_div1 <= ~clk_div1;
        end
    end

    // clk_div2 toggled on negative edge, synchronized by count value delayed via cnt_reg
    reg [CNT_WIDTH-1:0] cnt_reg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_reg  <= 0;
            clk_div2 <= 0;
        end else begin
            cnt_reg <= cnt;
            // Toggle clk_div2 when delayed count equals zero or halfway point
            if (cnt_reg == 0 || cnt_reg == HALF_DIV)
                clk_div2 <= ~clk_div2;
        end
    end

    // Output clock is OR of both divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule