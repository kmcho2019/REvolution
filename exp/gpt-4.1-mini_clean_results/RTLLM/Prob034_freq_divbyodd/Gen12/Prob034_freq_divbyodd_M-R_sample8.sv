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
    reg [CNT_WIDTH-1:0] cnt_dly;  // delayed counter for negedge domain

    reg clk_div1;
    reg clk_div2;

    // Counter increments modulo NUM_DIV on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= 0;
            cnt_dly  <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            cnt_dly <= cnt;

            // Toggle clk_div1 when count reaches HALF_DIV
            if (cnt == HALF_DIV)
                clk_div1 <= ~clk_div1;
        end
    end

    // Toggle clk_div2 on negedge clk when delayed count reaches HALF_DIV
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 1'b0;
        end else begin
            if (cnt_dly == HALF_DIV)
                clk_div2 <= ~clk_div2;
        end
    end

    assign clk_div = clk_div1 | clk_div2;

endmodule