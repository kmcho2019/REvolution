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

    // Counter and clk_div1 updated on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            if (cnt == HALF_DIV)
                clk_div1 <= ~clk_div1;
        end
    end

    // clk_div2 toggled on falling edge when cnt == 0
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 0;
        end else begin
            if (cnt == 0)
                clk_div2 <= ~clk_div2;
        end
    end

    // Combine clk_div1 and clk_div2 to generate final clk_div
    assign clk_div = clk_div1 | clk_div2;

endmodule