module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

// Define the counters for tracking clock cycles
logic [$clog2(NUM_DIV):0] cnt1, cnt2;

// Define the clock dividers for positive and negative edges
logic clk_div1, clk_div2;

// Initialize the counters and divided clock outputs on reset
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        // Increment the counter on each positive edge
        if (clk) begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                // Toggle clk_div1 when cnt1 reaches half of NUM_DIV
                if (NUM_DIV % 2 == 1) begin
                    if (cnt1 == (NUM_DIV / 2)) begin
                        clk_div1 <= ~clk_div1;
                    end
                end
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end

        // Increment the counter on each negative edge
        if (~clk) begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                // Toggle clk_div2 when cnt2 reaches half of NUM_DIV
                if (NUM_DIV % 2 == 1) begin
                    if (cnt2 == (NUM_DIV / 2)) begin
                        clk_div2 <= ~clk_div2;
                    end
                end
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end
end

// Derive the final divided clock output by logically OR-ing clk_div1 and clk_div2
assign clk_div = clk_div1 | clk_div2;

endmodule