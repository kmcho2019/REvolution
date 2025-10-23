module freq_divbyodd #(
    parameter integer NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,     // Active low reset
    output reg  clk_div
);

    // Compile-time check for odd NUM_DIV
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV parameter must be an odd number.");
        end
    end

    // Width for counter
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] counter;

    localparam HALF_COUNT = NUM_DIV >> 1;  // floor(NUM_DIV/2)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_div <= 0;
        end else begin
            if (counter == NUM_DIV - 1) begin
                counter <= 0;
                clk_div <= ~clk_div;
            end else if (counter == HALF_COUNT) begin
                counter <= counter + 1;
                clk_div <= ~clk_div;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule