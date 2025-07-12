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

    localparam integer HALF_DIV = NUM_DIV / 2;  // floor division

    // Width for counter (minimum bits to count up to NUM_DIV-1)
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt;

    reg clk_div1;
    reg clk_div2;

    // Pulse register to indicate toggle conditions for clk_div2 on negedge
    reg toggle_pulse;

    // Counter and clk_div1 toggling on positive edge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt         <= 0;
            clk_div1    <= 1'b0;
            toggle_pulse <= 1'b0;
        end else begin
            // Counter counts modulo NUM_DIV
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // Toggle clk_div1 at count == 0 or HALF_DIV
            if (cnt == 0 || cnt == HALF_DIV)
                clk_div1 <= ~clk_div1;

            // Generate toggle pulse when toggling should occur for clk_div2 on next negedge clk
            toggle_pulse <= (cnt == 0 || cnt == HALF_DIV);
        end
    end

    // clk_div2 toggles on negedge clk when toggle_pulse was asserted on last posedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 1'b0;
        end else begin
            if (toggle_pulse)
                clk_div2 <= ~clk_div2;
        end
    end

    // Output combined by OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule