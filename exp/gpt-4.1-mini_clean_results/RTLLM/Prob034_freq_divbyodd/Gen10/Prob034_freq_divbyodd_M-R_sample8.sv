module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam HALF = (NUM_DIV - 1) / 2;

    // Counter width for NUM_DIV-1 max count
    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    reg [COUNTER_WIDTH-1:0] cnt_pos; // Count posedge clk cycles modulo NUM_DIV
    reg [COUNTER_WIDTH-1:0] cnt_neg; // Count negedge clk cycles modulo NUM_DIV

    // Counter for positive edge domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 0;
        end else begin
            if (cnt_pos == NUM_DIV - 1)
                cnt_pos <= 0;
            else
                cnt_pos <= cnt_pos + 1;
        end
    end

    // Counter for negative edge domain
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 0;
        end else begin
            if (cnt_neg == NUM_DIV - 1)
                cnt_neg <= 0;
            else
                cnt_neg <= cnt_neg + 1;
        end
    end

    // Generate clk_div1 and clk_div2 as level signals: high for first HALF+1 counts, low for remainder
    wire clk_div1 = (cnt_pos <= HALF);
    wire clk_div2 = (cnt_neg <= HALF);

    // Output is OR of clk_div1 and clk_div2, generating a clean odd frequency division with improved duty cycle
    assign clk_div = clk_div1 | clk_div2;

endmodule