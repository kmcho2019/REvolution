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

    localparam integer MAX_CNT = NUM_DIV - 1;
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counter for posedge clock domain
    reg [CNT_WIDTH-1:0] cnt_pos;
    reg clk_div1;

    // Counter for negedge clock domain
    reg [CNT_WIDTH-1:0] cnt_neg;
    reg clk_div2;

    // Posedge counter and clk_div1 toggling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos  <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt_pos == MAX_CNT)
                cnt_pos <= 0;
            else
                cnt_pos <= cnt_pos + 1;

            if (cnt_pos == 0)
                clk_div1 <= ~clk_div1;
        end
    end

    // Negedge counter and clk_div2 toggling
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg  <= 0;
            clk_div2 <= 1'b0;
        end else begin
            if (cnt_neg == MAX_CNT)
                cnt_neg <= 0;
            else
                cnt_neg <= cnt_neg + 1;

            if (cnt_neg == 0)
                clk_div2 <= ~clk_div2;
        end
    end

    // Output clock is OR of clk_div1 and clk_div2 for ~50% duty cycle
    assign clk_div = clk_div1 | clk_div2;

endmodule