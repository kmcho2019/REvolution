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

    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] counter;

    // Counter increments every clock cycle modulo NUM_DIV
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else begin
            if (counter == NUM_DIV - 1) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    // Half division count, integer division truncates
    localparam HALF_DIV = NUM_DIV >> 1;

    // Generate clk_div1 and clk_div2 from counter value
    // clk_div1 is high when counter < HALF_DIV + 1 (first half + 1 count)
    // clk_div2 is high when counter >= HALF_DIV + 1 (second half)
    wire clk_div1 = (counter <= HALF_DIV);
    wire clk_div2 = (counter >= HALF_DIV + 1);

    // Output clock is OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule