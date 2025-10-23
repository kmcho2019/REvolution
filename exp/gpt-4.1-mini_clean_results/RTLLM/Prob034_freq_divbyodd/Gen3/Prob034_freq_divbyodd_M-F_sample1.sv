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

    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    reg [COUNTER_WIDTH-1:0] cnt1;
    reg [COUNTER_WIDTH-1:0] cnt2;

    reg clk_div1;
    reg clk_div2;

    // Toggle points: half period (integer division)
    // For odd NUM_DIV, (NUM_DIV-1)/2 is the middle count for toggling
    localparam TOGGLE_COUNT = (NUM_DIV - 1) >> 1;

    // Rising edge logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1; // Toggle at wrap-around
            end else if (cnt1 == TOGGLE_COUNT) begin
                cnt1 <= cnt1 + 1;
                clk_div1 <= ~clk_div1; // Toggle at half-period count
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end
    end

    // Falling edge logic
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2; // Toggle at wrap-around
            end else if (cnt2 == TOGGLE_COUNT) begin
                cnt2 <= cnt2 + 1;
                clk_div2 <= ~clk_div2; // Toggle at half-period count
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end

    // Final divided clock output is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule