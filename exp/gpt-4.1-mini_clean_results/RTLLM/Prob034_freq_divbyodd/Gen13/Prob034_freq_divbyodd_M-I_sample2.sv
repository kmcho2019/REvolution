module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,    // Active low reset
    output wire clk_div
);

    // Compile-time check: NUM_DIV must be odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam HALF_DIV = NUM_DIV >> 1; // floor(NUM_DIV/2)
    localparam COUNTER_WIDTH = $clog2(NUM_DIV);

    reg [COUNTER_WIDTH-1:0] cnt1;    // Counter incremented on posedge clk
    reg [COUNTER_WIDTH-1:0] cnt2;    // Counter incremented on negedge clk

    reg clk_div1;  // Divided clock from posedge counter
    reg clk_div2;  // Divided clock from negedge counter

    // Positive edge logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;

            // Toggle clk_div1 when counter reaches HALF_DIV
            if (cnt1 == HALF_DIV)
                clk_div1 <= ~clk_div1;
        end
    end

    // Negative edge logic
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 1'b0;
        end else begin
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;

            // Toggle clk_div2 when counter reaches HALF_DIV
            if (cnt2 == HALF_DIV)
                clk_div2 <= ~clk_div2;
        end
    end

    // Output clock is OR of both divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule