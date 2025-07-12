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

    localparam integer HALF_DIV = NUM_DIV / 2;  // floor division

    // Width for counter (minimum bits to count up to NUM_DIV-1)
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counters for posedge and negedge clock domains
    reg [CNT_WIDTH-1:0] cnt_pos;
    reg [CNT_WIDTH-1:0] cnt_neg;

    // Divided clocks toggled on posedge and negedge respectively
    reg clk_div1;
    reg clk_div2;

    // Counter and toggle logic for posedge clk domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos  <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt_pos == NUM_DIV - 1)
                cnt_pos <= 0;
            else
                cnt_pos <= cnt_pos + 1;

            // Toggle clk_div1 when counter reaches HALF_DIV
            if (cnt_pos == HALF_DIV)
                clk_div1 <= ~clk_div1;
        end
    end

    // Counter and toggle logic for negedge clk domain
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg  <= 0;
            clk_div2 <= 1'b0;
        end else begin
            if (cnt_neg == NUM_DIV - 1)
                cnt_neg <= 0;
            else
                cnt_neg <= cnt_neg + 1;

            // Toggle clk_div2 when counter reaches HALF_DIV
            if (cnt_neg == HALF_DIV)
                clk_div2 <= ~clk_div2;
        end
    end

    // Final divided clock output is OR of both toggles to combine posedge and negedge contributions
    assign clk_div = clk_div1 | clk_div2;

endmodule