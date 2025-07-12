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

    localparam integer HALF_DIV = NUM_DIV / 2;

    // Minimal width counters
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt1;    // posedge counter
    reg [CNT_WIDTH-1:0] cnt2;    // negedge counter

    reg clk_div1;
    reg clk_div2;

    // posedge clock counter and toggle clk_div1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1     <= 0;
            clk_div1 <= 0;        // start from 0
        end else begin
            // Increment counter, wrap at NUM_DIV-1
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;

            // Toggle clk_div1 at cnt1 == 0 to mark start of half cycle
            if (cnt1 == 0)
                clk_div1 <= ~clk_div1;
        end
    end

    // negedge clock counter and toggle clk_div2
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2     <= 0;
            clk_div2 <= 1;        // start opposite to clk_div1 to offset phase
        end else begin
            // Increment counter, wrap at NUM_DIV-1
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;

            // Toggle clk_div2 at cnt2 == HALF_DIV to stagger toggling
            if (cnt2 == HALF_DIV)
                clk_div2 <= ~clk_div2;
        end
    end

    // Combined divided clock output is OR of two halves
    assign clk_div = clk_div1 | clk_div2;

endmodule