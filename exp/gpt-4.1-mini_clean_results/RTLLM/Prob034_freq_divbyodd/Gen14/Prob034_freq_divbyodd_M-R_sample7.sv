module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output wire clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer HALF_DIV = NUM_DIV / 2; // floor division

    // Minimum width for counter and state
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] state;
    reg clk_div1, clk_div2;

    // FSM and toggling clk_div1 & clk_div2 on specific states, all synchronous on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= 0;
            clk_div1 <= 0;
            clk_div2 <= 0;
        end else begin
            // Advance state counter cyclically
            if (state == NUM_DIV - 1)
                state <= 0;
            else
                state <= state + 1;

            // Toggle clk_div1 and clk_div2 on states 0 and HALF_DIV
            // We simulate two toggle events per full cycle by toggling clk_div1 and clk_div2 alternatively on these counts
            if (state == 0) begin
                clk_div1 <= ~clk_div1;
                clk_div2 <= ~clk_div2;
            end else if (state == HALF_DIV) begin
                clk_div1 <= ~clk_div1;
                clk_div2 <= ~clk_div2;
            end
        end
    end

    // Output clock is OR of both divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule