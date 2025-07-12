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

    // Counter and clk_div1 generation on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1) begin
                cnt <= 0;
            end else begin
                cnt <= cnt + 1;
            end

            // clk_div1 set high at count 0, cleared at HALF_DIV
            if (cnt == 0) begin
                clk_div1 <= 1'b1;
            end else if (cnt == HALF_DIV) begin
                clk_div1 <= 1'b0;
            end
            // Otherwise maintain current clk_div1
        end
    end

    // Delay counter value to negedge domain synchronously
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_dly <= 0;
        end else begin
            cnt_dly <= cnt;
        end
    end

    // clk_div2 generation on negative edge using delayed counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 1'b0;
        end else begin
            // clk_div2 set high at delayed count 0, cleared at HALF_DIV
            if (cnt_dly == 0) begin
                clk_div2 <= 1'b1;
            end else if (cnt_dly == HALF_DIV) begin
                clk_div2 <= 1'b0;
            end
            // Otherwise maintain current clk_div2
        end
    end

    // Final output is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule