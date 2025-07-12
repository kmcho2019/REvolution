module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] count;          // Modulo-7 counter: counts from 0 to 6
    reg       clk_long;       // Intermediate clock with 4-cycle high time (posedge clk)
    reg       clk_short;      // Intermediate clock with 3-cycle high time (negedge clk)

    // Counter: counts 0..6 on posedge clk, resets asynchronously
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else begin
            if (count == 3'd6)
                count <= 3'd0;
            else
                count <= count + 3'd1;
        end
    end

    // clk_long generation:
    // Toggle clk_long at count 0 on posedge clk to generate 4-cycle high pulse (counts 0..3)
    reg clk_long_en;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_long <= 1'b0;
            clk_long_en <= 1'b0;
        end else begin
            // Enable pulse high for counts 0..3, low otherwise
            clk_long_en <= (count <= 3'd3);

            // Toggle clk_long at count == 0 (rising edge of enable)
            if (count == 3'd0)
                clk_long <= 1'b1;
            else if (count == 3'd4)
                clk_long <= 1'b0;
        end
    end

    // clk_short generation:
    // Toggle clk_short at negedge clk with 3-cycle high pulse (counts 0..2)
    reg [2:0] count_d;      // delayed count for negedge clk sampling
    reg clk_short_en;

    // Sample count at posedge clk for use at negedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count_d <= 3'd0;
        else
            count_d <= count;
    end

    // Generate clk_short on negedge clk based on delayed count_d
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_short <= 1'b0;
            clk_short_en <= 1'b0;
        end else begin
            // Enable pulse high for counts 0..2, low otherwise
            clk_short_en <= (count_d <= 3'd2);

            // Toggle clk_short high at count == 0 (start of short pulse)
            if (count_d == 3'd0)
                clk_short <= 1'b1;
            else if (count_d == 3'd3)
                clk_short <= 1'b0;
        end
    end

    // Final divided clock is the OR of two intermediate clocks
    assign clk_div = clk_long | clk_short;

endmodule