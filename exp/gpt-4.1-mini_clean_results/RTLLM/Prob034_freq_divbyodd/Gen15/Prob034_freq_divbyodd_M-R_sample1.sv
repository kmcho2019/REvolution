module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
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

    localparam MID_VAL = (NUM_DIV - 1) / 2;
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt1;    // Counter for posedge clk
    reg [CNT_WIDTH-1:0] cnt2;    // Counter for negedge clk

    reg clk_div1;
    reg clk_div2;

    // Positive edge counter and clk_div1 toggling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1     <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end

            if (cnt1 == MID_VAL) begin
                clk_div1 <= ~clk_div1;
            end
        end
    end

    // Negative edge counter and clk_div2 toggling
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2     <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end

            if (cnt2 == MID_VAL) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end

    // Final output is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule