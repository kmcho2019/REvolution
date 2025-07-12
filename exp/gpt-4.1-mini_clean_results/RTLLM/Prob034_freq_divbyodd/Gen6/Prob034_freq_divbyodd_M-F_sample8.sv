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

    // Local parameters
    localparam HALF = NUM_DIV / 2;  // integer division truncates fractional part

    // Width of counters
    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    // Counters
    reg [COUNTER_WIDTH-1:0] cnt1;   // counts on positive edges
    reg [COUNTER_WIDTH-1:0] cnt2;   // counts on negative edges

    // Clock dividers toggled on positive and negative edges
    reg clk_div1;
    reg clk_div2;

    // Positive edge block: cnt1 and clk_div1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;  // Toggle at end of full count
            end else begin
                cnt1 <= cnt1 + 1;
                if (cnt1 == HALF) begin
                    clk_div1 <= ~clk_div1;  // Toggle at half count
                end
            end
        end
    end

    // Negative edge block: cnt2 and clk_div2
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;  // Toggle at end of full count
            end else begin
                cnt2 <= cnt2 + 1;
                if (cnt2 == HALF) begin
                    clk_div2 <= ~clk_div2;  // Toggle at half count
                end
            end
        end
    end

    // Output clock is logical OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule