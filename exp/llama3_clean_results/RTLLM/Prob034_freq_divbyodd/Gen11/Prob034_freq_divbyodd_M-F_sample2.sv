module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

// Define the counters for tracking rising and falling edges
logic [$clog2(NUM_DIV-1):0] cnt1;
logic [$clog2(NUM_DIV-1):0] cnt2;

// Define the clock dividers for positive and negative edges
logic clk_div1;
logic clk_div2;

// Initialize the counters and clock dividers on reset
always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        // Increment the counters on each clock cycle
        if (cnt1 == (NUM_DIV / 2) - 1) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end else begin
            cnt1 <= cnt1 + 1;
        end

        if (cnt2 == (NUM_DIV / 2) - 1) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

// Assign the divided clock output to the output port
assign clk_div = clk_div1 | clk_div2;

endmodule