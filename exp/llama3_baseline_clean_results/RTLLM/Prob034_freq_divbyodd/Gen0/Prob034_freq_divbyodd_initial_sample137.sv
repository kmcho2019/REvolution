module freq_divbyodd #(
    parameter NUM_DIV = 5  // Default divisor value
) (
    input clk,
    input rst_n,
    output reg clk_div
);

// Internal counters for tracking clock edges
reg [$(ceil($clog2(NUM_DIV))) - 1:0] cnt1;
reg [$(ceil($clog2(NUM_DIV))) - 1:0] cnt2;

// Internal clock dividers for positive and negative edges
reg clk_div1;
reg clk_div2;

// Calculate half of the divisor value
localparam HALF_DIV = (NUM_DIV - 1) / 2;

// Counter increments and clock divider toggles
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counters and clock dividers
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else begin
        // Count up for positive edge
        if (cnt1 < NUM_DIV - 1) begin
            cnt1 <= cnt1 + 1;
        end else begin
            cnt1 <= 0;
            // Toggle clk_div1 when cnt1 reaches half of NUM_DIV
            if (cnt1 == HALF_DIV) begin
                clk_div1 <= ~clk_div1;
            end
        end

        // Count up for negative edge
        if (cnt2 < NUM_DIV - 1) begin
            cnt2 <= cnt2 + 1;
        end else begin
            cnt2 <= 0;
            // Toggle clk_div2 when cnt2 reaches half of NUM_DIV
            if (cnt2 == HALF_DIV) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end
end

// Derive final divided clock output by OR-ing clk_div1 and clk_div2
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 0;
    end else begin
        clk_div <= clk_div1 | clk_div2;
    end
end

endmodule