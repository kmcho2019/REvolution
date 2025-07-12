module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output reg  clk_div
);

    // Compile-time check that NUM_DIV is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    // Counter width
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Calculate half count floor(NUM_DIV/2)
    localparam HALF_COUNT = NUM_DIV >> 1;

    reg [CNT_WIDTH-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            if (counter == NUM_DIV - 1) begin
                counter <= 0;
                clk_div <= ~clk_div;      // Toggle at end of count
            end else begin
                counter <= counter + 1;
                if (counter == HALF_COUNT) begin
                    clk_div <= ~clk_div;  // Toggle at half count
                end
            end
        end
    end

endmodule