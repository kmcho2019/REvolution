module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be an odd number
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Check that NUM_DIV is odd at compile time
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    // Half point for toggling
    localparam integer HALF_DIV = (NUM_DIV - 1) >> 1;

    // Counter width
    localparam integer CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt_pos;
    reg [CNT_WIDTH-1:0] cnt_neg;

    reg clk_div_pos;
    reg clk_div_neg;

    // Counter and toggle on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos    <= 0;
            clk_div_pos <= 0;
        end else begin
            if (cnt_pos == NUM_DIV - 1)
                cnt_pos <= 0;
            else
                cnt_pos <= cnt_pos + 1;

            // Toggle clk_div_pos only at half count (phase offset)
            if (cnt_pos == HALF_DIV)
                clk_div_pos <= ~clk_div_pos;
        end
    end

    // Counter and toggle on negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg    <= 0;
            clk_div_neg <= 0;
        end else begin
            if (cnt_neg == NUM_DIV - 1)
                cnt_neg <= 0;
            else
                cnt_neg <= cnt_neg + 1;

            // Toggle clk_div_neg only at full count (0-based max)
            if (cnt_neg == NUM_DIV - 1)
                clk_div_neg <= ~clk_div_neg;
        end
    end

    // Final divided clock output by OR-ing phase-shifted halves
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule