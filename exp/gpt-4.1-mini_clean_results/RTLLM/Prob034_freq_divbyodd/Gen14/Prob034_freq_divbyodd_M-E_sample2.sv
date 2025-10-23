module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd and >=3
)(
    input  wire clk,
    input  wire rst_n,   // Active low synchronous reset
    output reg  clk_div
);

    // Compile-time checks
    initial begin
        if (NUM_DIV < 3) begin
            $error("NUM_DIV parameter must be >= 3.");
        end
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be odd.");
        end
    end

    localparam HALF_DIV = NUM_DIV / 2;
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] counter;

    always @(posedge clk) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            // Increment counter modulo NUM_DIV
            if (counter == NUM_DIV - 1)
                counter <= 0;
            else
                counter <= counter + 1;

            // Toggle clk_div at counts 0 and HALF_DIV
            if (counter == 0 || counter == HALF_DIV)
                clk_div <= ~clk_div;
        end
    end

endmodule