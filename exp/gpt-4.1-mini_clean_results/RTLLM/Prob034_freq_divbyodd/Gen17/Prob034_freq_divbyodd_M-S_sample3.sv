module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be an odd number
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    localparam integer CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            if (counter == NUM_DIV - 1)
                counter <= 0;
            else
                counter <= counter + 1;

            // Toggle clk_div at midpoint count to create a near 50% duty cycle
            if (counter == (NUM_DIV - 1) >> 1)
                clk_div <= ~clk_div;
        end
    end

endmodule