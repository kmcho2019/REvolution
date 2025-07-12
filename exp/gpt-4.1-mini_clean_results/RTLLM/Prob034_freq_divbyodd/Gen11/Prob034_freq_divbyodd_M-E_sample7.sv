module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Check that NUM_DIV is odd at elaboration time
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
            $finish;
        end
    end

    // Calculate half divisor for toggling
    localparam integer HALF_DIV = NUM_DIV >> 1; // integer division by 2

    // Counter width needed to count up to NUM_DIV-1
    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    // Positive edge counter and clk_div1
    reg [COUNTER_WIDTH-1:0] cnt1;
    reg clk_div1;

    // Negative edge counter and clk_div2
    reg [COUNTER_WIDTH-1:0] cnt2;
    reg clk_div2;

    // Counter and toggle logic for positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else if (cnt1 == HALF_DIV - 1) begin
                // Toggle clk_div1 at half period count as well for correct waveform
                clk_div1 <= ~clk_div1;
                cnt1 <= cnt1 + 1;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end
    end

    // Counter and toggle logic for negative edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else if (cnt2 == HALF_DIV - 1) begin
                // Toggle clk_div2 at half period count to match clk_div1's behavior
                clk_div2 <= ~clk_div2;
                cnt2 <= cnt2 + 1;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end

    // Output clock is OR of clk_div1 and clk_div2 to merge positive and negative edge toggles
    assign clk_div = clk_div1 | clk_div2;

endmodule