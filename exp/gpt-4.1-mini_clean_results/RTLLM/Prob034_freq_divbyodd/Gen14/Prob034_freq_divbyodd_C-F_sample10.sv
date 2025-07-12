module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low asynchronous reset
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

    // Single counter running on positive clock edge
    reg [CNT_WIDTH-1:0] cnt;
    // Delayed counter value for use in negedge domain
    reg [CNT_WIDTH-1:0] cnt_dly;

    // Clock divider registers for positive and negative edges
    reg clk_div1, clk_div2;

    // Counter and clk_div1 generation on positive clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= 0;
            clk_div1 <= 1'b0;
        end else begin
            // Counter counts 0 to NUM_DIV-1 cyclically
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            // clk_div1 set high at count 0, cleared at HALF_DIV
            if (cnt == 0)
                clk_div1 <= 1'b1;
            else if (cnt == HALF_DIV)
                clk_div1 <= 1'b0;
            // Else hold clk_div1
        end
    end

    // Delay the counter for use in negedge domain synchronously on positive clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_dly <= 0;
        else
            cnt_dly <= cnt;
    end

    // clk_div2 generation on negative clock edge using delayed counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 1'b0;
        end else begin
            // clk_div2 set high at delayed count 0, cleared at HALF_DIV
            if (cnt_dly == 0)
                clk_div2 <= 1'b1;
            else if (cnt_dly == HALF_DIV)
                clk_div2 <= 1'b0;
            // Else hold clk_div2
        end
    end

    // Final divided clock output is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule