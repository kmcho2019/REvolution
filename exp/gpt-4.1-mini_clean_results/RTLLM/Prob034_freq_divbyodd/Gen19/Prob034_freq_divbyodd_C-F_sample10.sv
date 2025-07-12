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

    // Counter on positive clock edge
    reg [CNT_WIDTH-1:0] cnt;
    // Delayed counter for negative clock edge domain
    reg [CNT_WIDTH-1:0] cnt_dly;

    // Divided clock outputs for positive and negative edge halves
    reg clk_div1, clk_div2;

    // Positive edge domain: counter and clk_div1 generation with explicit set/reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt      <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (cnt == NUM_DIV - 1)
                cnt <= 0;
            else
                cnt <= cnt + 1;

            if (cnt == 0)
                clk_div1 <= 1'b1;    // Set high at start of cycle
            else if (cnt == HALF_DIV)
                clk_div1 <= 1'b0;    // Clear halfway
            // else hold clk_div1
        end
    end

    // Delay the counter to use in negedge clock domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_dly <= 0;
        end else begin
            cnt_dly <= cnt;
        end
    end

    // Negative edge domain: generate clk_div2 with explicit set/reset using delayed counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div2 <= 1'b0;
        end else begin
            if (cnt_dly == 0)
                clk_div2 <= 1'b1;    // Set high at start of cycle
            else if (cnt_dly == HALF_DIV)
                clk_div2 <= 1'b0;    // Clear halfway
            // else hold clk_div2
        end
    end

    // Final output is logical OR of positive and negative edge divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule