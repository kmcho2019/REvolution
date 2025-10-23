module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be an odd number
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Compile-time check that NUM_DIV is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("Parameter NUM_DIV must be an odd number. Current: %0d", NUM_DIV);
        end
    end

    localparam integer HALF_DIV = (NUM_DIV - 1) >> 1;
    localparam integer CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;
    reg clk_div1;  // toggled at halfway count on posedge clk
    reg clk_div2;  // toggled at full count on negedge clk

    // Counter increments on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // Toggle clk_div1 at halfway count on posedge clk
            if (cnt == HALF_DIV)
                clk_div1 <= ~clk_div1;
        end
    end

    // Toggle clk_div2 on negedge clk when counter is at full count (NUM_DIV-1)
    // Use sampled value of cnt on negedge clk
    // Because cnt is updated only on posedge clk, cnt is stable during negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                clk_div2 <= ~clk_div2;
        end
    end

    // Combine clk_div1 and clk_div2 with OR to generate clk_div with nearly 50% duty cycle
    assign clk_div = clk_div1 | clk_div2;

endmodule